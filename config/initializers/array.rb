class Array
  def count_by(&block)
    groupings = self.group_by(&block)
    groupings.each do |key, group|
      groupings[key] = group.size
    end
    groupings
  end

  def counts
    count_by {|o| o }
  end

  def groups
    group_by {|o| o }
  end

end

