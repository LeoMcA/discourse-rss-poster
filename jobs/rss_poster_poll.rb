require 'open-uri'
require 'simple-rss'
require 'htmlentities'

module Jobs
  class RssPosterPoll < Jobs::Base

    sidekiq_options retry: false

    def execute(args)
      id = args[:feed_id]
      Jobs.cancel_scheduled_job(:rss_poster_poll, feed_id: id)

      feed = RssPoster::Feed.find(id)
      feed.last_run = Time.now
      feed.failures = 0
      feed.exceptions = ''
      feed.status = 'running'
      feed.save!

      begin
        regexp_title = Regexp.new(feed.regexp_title_pattern.to_s, feed.regexp_title_options.to_s)
        regexp_body = Regexp.new(feed.regexp_body_pattern.to_s, feed.regexp_body_options.to_s)

        rss = SimpleRSS.parse open(feed.url, allow_redirections: :all)

        rss.items.each do |item|
          begin
            url = TopicEmbed.normalize_url(item.link)
            content = item.content_encoded.try(:force_encoding, 'UTF-8').try(:scrub).try(:gsub, regexp_body, feed.regexp_body_replacement.to_s) ||
                      item.content.try(:force_encoding, 'UTF-8').try(:scrub).try(:gsub, regexp_body, feed.regexp_body_replacement.to_s) ||
                      item.description.try(:force_encoding, 'UTF-8').try(:scrub).try(:gsub, regexp_body, feed.regexp_body_replacement.to_s)
            content << "\n<hr> <small>#{feed.link_text} <a href='#{url}'>#{url}</a></small>\n" if feed.add_link
            title = HTMLEntities.new(:expanded).decode(item.title.force_encoding('UTF-8').scrub).gsub(regexp_title, feed.regexp_title_replacement.to_s)
            item_sha1 = Digest::SHA1.hexdigest(title + content)

            custom_field = PostCustomField.find_by(name: 'rss_poster_id', value: url)

            if custom_field.nil?
              feed.use_timestamps ? created_at = item.pubDate : created_at = Time.now
              creator = PostCreator.new(feed.user,
                                        title: title,
                                        raw: TopicEmbed.absolutize_urls(url, content),
                                        skip_validations: true,
                                        bypass_rate_limiter: true,
                                        cook_method: Post.cook_methods[:raw_html],
                                        category: feed.category.id,
                                        custom_fields: { :rss_poster_id => url, :rss_poster_sha1 => item_sha1 },
                                        created_at: created_at)
              creator.create
            else
              post = custom_field.post
              post_sha1 = post.custom_fields['rss_poster_sha1']
              if item_sha1 != post_sha1
                post.revise(feed.user,
                            title: title,
                            raw: TopicEmbed.absolutize_urls(url, content),
                            skip_validations: true,
                            bypass_rate_limiter: true,
                            skip_revision: true)
                post.custom_fields['rss_poster_sha1'] = item_sha1
                post.save!
              end
            end
          rescue Exception => e
            feed.failures += 1
            feed.exceptions << e.message << '&#10;'
          end
        end

        feed.status = 'success'
        feed.save!
      rescue Exception => e
        feed.status = 'error'
        feed.exception = e.message
        feed.save!
      end

      interval = feed.interval.to_i
      Jobs.enqueue_in(interval.minutes, :rss_poster_poll, feed_id: id)
    end
  end
end
