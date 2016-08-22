module RssPoster
  class FeedsController < Admin::AdminController
    requires_plugin 'rss-poster'

    def index
      feeds = Feed.all
      render json: feeds.to_json(:include => [:category, :user])
    end

    def new
    end

    def create
      feed = Feed.new(feed_params)
      feed.save!
      Jobs.enqueue(:rss_poster_poll, feed_id: feed.id)
      render nothing: true, status: 204
    end

    def show
      feed = Feed.find(params[:id])
      render json: feed.to_json(:include => [:category, :user])
    end

    def update
      feed = Feed.find(params[:id])
      feed.update_attributes!(feed_params)
      Jobs.enqueue(:rss_poster_poll, feed_id: feed.id)
      render nothing: true, status: 204
    end

    def destroy
      feed = Feed.find(params[:id])
      Jobs.cancel_scheduled_job(:rss_poster_poll, feed_id: feed.id)
      feed.delete!
      render nothing: true, status: 204
    end

    private

    def feed_params
      user = User.find_by_username(params[:username])
      params.permit(:url, :category_id, :interval).merge({ :user_id => user.id })
    end
  end
end
