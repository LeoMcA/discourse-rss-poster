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
      feed.delete
      render nothing: true, status: 204
    end

    private

    def feed_params
      user = User.find_by_username(params[:username])
      params[:category_id] = 1 if params[:category_id].to_i == 0
      params.permit(:url,
                    :category_id,
                    :interval,
                    :regexp_title_pattern,
                    :regexp_title_options,
                    :regexp_title_replacement,
                    :regexp_body_pattern,
                    :regexp_body_options,
                    :regexp_body_replacement,
                    :add_link,
                    :link_text,
                    :use_timestamps).merge({ :user_id => user.id })
    end
  end
end
