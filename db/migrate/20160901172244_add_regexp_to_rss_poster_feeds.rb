class AddRegexpToRssPosterFeeds < ActiveRecord::Migration
  def change
    add_column :rss_poster_feeds, :regexp_title_pattern, :string
    add_column :rss_poster_feeds, :regexp_title_options, :string
    add_column :rss_poster_feeds, :regexp_title_replacement, :string
    add_column :rss_poster_feeds, :regexp_body_pattern, :string
    add_column :rss_poster_feeds, :regexp_body_options, :string
    add_column :rss_poster_feeds, :regexp_body_replacement, :string
    add_column :rss_poster_feeds, :add_link, :boolean
    add_column :rss_poster_feeds, :link_text, :text
  end
end
