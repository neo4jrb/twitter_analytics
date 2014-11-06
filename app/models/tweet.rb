class Tweet
  include Neo4j::ActiveNode
  set_mapped_label_name :TwitterTweet

  property :id
  property :text

  has_many :out, :hash_tags, type: :has_hashtag
  has_one :in, :user, origin: :tweets
end
