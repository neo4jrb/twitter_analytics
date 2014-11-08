class HomeController < ApplicationController
  def index

  end

  def tweets_per_minute
    data = Tweet.query_as(:tweet).match('tweet-[:retweets]-()').where('NOT(()-[:retweets]->tweet)').pluck(tweet: :created_at).count_by do |created_at|
      datetime = DateTime.strptime(created_at, '%Y-%m-%d %H:%M:%S %z')

      datetime.strftime('%Y-%m-%d %H:') + (datetime.strftime('%M').to_i / 10).to_s + '0'
    end

    render json: data.to_json
  end
end
