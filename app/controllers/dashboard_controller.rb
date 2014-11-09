class DashboardController < ApplicationController
  def index
  end

  PANELS = {
    middle: '',
    left: []
    
  }

  def panel
    params[:panel]
  end

  def data
    # VULNERABILITY!
    render json: send(params[:metric]).to_json
  end

  def top_tweeters
    Hash[*User.as(:user).tweets(:tweet).order('COUNT(tweet) DESC').limit(5).pluck('user.screen_name, COUNT(tweet)').flatten]
  end

  def top_retweeters
    query = User.as(:user).tweets(:retweet).where('retweet-[:retweets]->()')

    Hash[*query.order('COUNT(retweet) DESC').limit(5).pluck('user.screen_name, COUNT(retweet)').flatten]
  end

  def tweets_per_minute
    query_proxy = original_tweets

    max = query_proxy.pluck("MAX(tweet.created_at)").first
    min = query_proxy.pluck("MIN(tweet.created_at)").first

    if min && max
      max = Tweet.parse_twitter_datetime(max)
      min = Tweet.parse_twitter_datetime(min)

      # Number of seconds
      grouping = case (max.to_i - min.to_i)
                 when (0..1.minute)
                   :second
                 when (1.minute..3.hours)
                   :minute
                 when (3.hours..3.days)
                   :hour
                 else
                   :day
                 end

      max - min

      Tweet.counts_by(:created_at, grouping, query_proxy)
    else
      {}
    end
  end

  def most_favorited_tweets
    Hash[*original_tweets.order(favorite_count: :desc).limit(5).pluck('tweet.id', 'tweet.favorite_count').flatten]
  end

  def most_retweeted_tweets
    Hash[*original_tweets.order(retweet_count: :desc).limit(5).pluck('tweet.id', 'tweet.retweet_count').flatten]
  end




  def original_tweets
    Tweet.as(:tweet).where('NOT(()-[:retweets]->tweet)')
  end
end
