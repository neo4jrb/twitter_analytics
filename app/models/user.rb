class User
  include Neo4j::ActiveNode
  set_mapped_label_name :TwitterUser

  property :id
  property :screen_name
  property :name
  property :location
end

