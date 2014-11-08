class Tweet
  include Neo4j::ActiveNode
  set_mapped_label_name :TwitterTweet

  property :id
  property :text
  property :created_at

  has_many :out, :hash_tags, type: :has_hashtag
  has_one :in, :user, origin: :tweets

  def created_at
    DateTime.strptime(read_attribute(:created_at), '%Y-%m-%d %H:%M:%S %z')
  end
end
