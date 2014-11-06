module HasTweets
  extend ActiveSupport::Concern

  def top_associated_hash_tag_counts(limit = nil)
    query = tweets(:tweet).hash_tags(:other_hash_tag).query.with(count: 'COUNT(tweet)', hash_tag: :other_hash_tag).order("COUNT(tweet) DESC").break

    query = query.limit(limit) if limit

    Hash[*query.pluck(:hash_tag, :count).flatten]
  end

  def top_associated_users(limit = nil)
    query = tweets(:tweet).user(:other_user).query.with(count: 'COUNT(tweet)', user: :other_user).order("COUNT(tweet) DESC").break

    query = query.limit(limit) if limit

    Hash[*query.pluck(:user, :count).flatten]
  end
end
