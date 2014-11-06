class HashTag
  include Neo4j::ActiveNode
  set_mapped_label_name :TwitterHashTag

  id_property :text

  has_many :in, :tweets, origin: :hash_tags

  def similar_hash_tag_counts(limit = nil)
    query = tweets(:tweet).hash_tags(:other_hash_tag).query.with(count: 'COUNT(tweet)', hash_tag: :other_hash_tag).order("COUNT(tweet) DESC").break

    query = query.limit(limit) if limit

    Hash[*query.pluck(:hash_tag, :count).flatten]
  end
end


