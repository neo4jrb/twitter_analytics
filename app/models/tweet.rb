class Tweet
  include Neo4j::ActiveNode
  set_mapped_label_name :TwitterTweet

  id_property :id
  property :text
  property :created_at

  property :oembed_html_cache

  has_many :out, :hash_tags, type: :has_hashtag
  has_one :in, :user, origin: :tweets

  # Not safe from injection
  def self.counts_by(field, time_period, tweet_query_proxy = Tweet)
    return_string = case time_period.to_sym
                    when :second
                      "substring(tweet.#{field}, 0, 19) + substring(tweet.created_at, 19, 6)"
                    when :minute
                      "substring(tweet.#{field}, 0, 16) + substring(tweet.created_at, 19, 6)"
                    when :hour
                      "substring(tweet.#{field}, 0, 13) + substring(tweet.created_at, 19, 6)"
                    when :day
                      "substring(tweet.#{field}, 0, 10)"
                    when :month
                      "substring(tweet.#{field}, 0, 7)"
                    when :year
                      "substring(tweet.#{field}, 0, 4)"
                    end


    Hash[*tweet_query_proxy.query_as(:tweet).order('datetime_string').pluck("#{return_string} AS datetime_string", 'COUNT(*)').flatten]
  end

  def oembed_html
    return self.oembed_html_cache if self.oembed_html_cache.present?

    TWITTER_REST_CLIENT.oembed(self.id).html.tap do |html|
      self.oembed_html_cache = html
      self.save
    end
  end

end
