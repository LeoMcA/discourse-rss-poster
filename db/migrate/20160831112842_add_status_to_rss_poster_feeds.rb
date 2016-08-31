class AddStatusToRssPosterFeeds < ActiveRecord::Migration
  def change
    add_column :rss_poster_feeds, :last_run, :datetime
    add_column :rss_poster_feeds, :status, :string
    add_column :rss_poster_feeds, :exception, :string
  end
end
