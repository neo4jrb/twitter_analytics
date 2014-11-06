class User
  include Neo4j::ActiveNode
  set_mapped_label_name :TwitterUser

  has_many :out, :tweets, type: :tweeted
  include HasTweets

  property :id
  id_property :screen_name
  property :name
  property :description
  property :location
  property :profile_image_url
#  property :created_at
  property :utc_offset
  property :time_zone
  property :lang
  property :followers_count
  property :verified?
  property :geo_enabled?

end

