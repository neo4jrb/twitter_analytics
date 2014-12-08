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

  def to_sigma_json(additional_attributes = {})
    {
      text: text.downcase,
      id: id
    }.merge(additional_attributes)
  end

  def local_graph_to_sigma_json
    first_level_hash_tags = tweets(:tweet).hash_tags(:other_tag).order("COUNT(tweet) DESC").limit(10).pluck(:other_tag, "COUNT(tweet)").map(&:first)
    second_level_hash_tags = tweets(:tweet).hash_tags.tweets.hash_tags(:other_tag).order("COUNT(tweet) DESC").limit(20).pluck(:other_tag, "COUNT(tweet)").map(&:first)

    all_hash_tags = [self] + first_level_hash_tags.to_a + second_level_hash_tags.to_a

    all_edges = []
#    t.query_as(:hash_tag).match("hash_tag<-[:has_hashtag]-(tweet:TwitterTweet)-[:has_hashtag]->(other_hash_tag:") .tweets(:tweet).hash_tags(:other_hash_tag).where('ID(hash_tag) IN {hash_tag_ids} AND ID(other_hash_tag) IN {hash_tag_ids}').params(hash_tag_ids: all_hash_tags.map(&:neo_id)).pluck(:hash_tag, "COUNT(tweet)", :other_hash_tag)

    Tweet.as(:tweet).hash_tags(:hash_tag).query.match("tweet-[:has_hashtag]->(other_hash_tag:TwitterHashTag)").where('ID(hash_tag) IN {hash_tag_ids} AND ID(other_hash_tag) IN {hash_tag_ids}').params(hash_tag_ids: all_hash_tags.map(&:neo_id)).
      pluck(:hash_tag, "COUNT(tweet)", :other_hash_tag).uniq do |hash_tag, _, other_hash_tag|
        [hash_tag.id, other_hash_tag.id].sort.join
      end.each_with_index do |(hash_tag, count, other_hash_tag), index|
        all_edges << {
          source: hash_tag.id,
          target: other_hash_tag.id,
          count: count,
          id: "edge#{index}"
        }
      end

    all_hash_tags_data = [self.to_sigma_json(primary_focus: true)]
    all_hash_tags_data += first_level_hash_tags.map {|hash_tag| hash_tag.to_sigma_json(secondary_focus: true) }
    all_hash_tags_data += second_level_hash_tags.map(&:to_sigma_json)
    all_hash_tags_data.uniq! {|datum| datum[:id] }

    {
      nodes: all_hash_tags_data,
      edges: all_edges
    }
  end


end


