class HashTag
  include Neo4j::ActiveNode
  set_mapped_label_name :TwitterHashTag

  id_property :text

  has_many :in, :tweets, origin: :hash_tags
  include HasTweets

end


