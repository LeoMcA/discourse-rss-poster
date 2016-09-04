class AddUseTimestampsToRssPosterFeeds < ActiveRecord::Migration
  def change
    add_column :rss_poster_feeds, :use_timestamps, :boolean
  end
end
