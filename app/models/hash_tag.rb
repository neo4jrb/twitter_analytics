class HashTag
  include Neo4j::ActiveNode
  set_mapped_label_name :TwitterHashTag

  id_property :text

  has_many :in, :tweets, origin: :hash_tags
  include HasTweets

  def self.top_with_tweet_counts(limit = nil)
    query = as(:hash_tag).tweets(:tweet).order("COUNT(tweet) DESC")

    query = query.limit(limit) if limit

    Hash[*query.pluck(:hash_tag, 'COUNT(tweet)').flatten]
  end

end


