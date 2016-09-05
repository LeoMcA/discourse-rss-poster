# name: rss-poster
# about: Discourse plugin which creates posts from feeds
# version: 0.1
# authors: Leo McArdle
# url: https://github.com/LeoMcA/discourse-rss-poster

load File.expand_path('../lib/rss_poster.rb', __FILE__)
load File.expand_path('../lib/rss_poster/engine.rb', __FILE__)

register_asset 'stylesheets/rss_poster.scss'

after_initialize do
  load File.expand_path('../jobs/rss_poster_poll.rb', __FILE__)
  RssPoster::Feed.all.each do |feed|
    Jobs.cancel_scheduled_job(:rss_poster_poll, feed_id: feed.id)
    Jobs.enqueue_in(5.seconds, :rss_poster_poll, feed_id: feed.id)
  end
end

add_admin_route 'rss_poster.title', 'rss-poster.feeds'

Discourse::Application.routes.append do
  mount RssPoster::Engine => '/admin/plugins/rss-poster', constraints: StaffConstraint.new
end
