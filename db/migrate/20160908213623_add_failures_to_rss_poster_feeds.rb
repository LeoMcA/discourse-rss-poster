class AddFailuresToRssPosterFeeds < ActiveRecord::Migration
  def change
    add_column :rss_poster_feeds, :failures, :integer
    add_column :rss_poster_feeds, :exceptions, :text
  end
end
