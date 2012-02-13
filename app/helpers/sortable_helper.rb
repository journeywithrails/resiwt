module SortableHelper
  
  def options_for_sortable_people(label="sort")
    available = [
      ["Tweasier Influence (most influential)", "influence_descending"],
      ["Tweasier Influence (least influential)", "influence_ascending"],
      ["Recently added", "recent"],
      ["Active (activity within the last #{Configuration.sorting.inactivity_period} days)", "active"],
      ["Dormant (no activity in at least #{Configuration.sorting.inactivity_period} days)", "dormant"],
      ["Alphabetical (ascending)", "ascending"],
      ["Alphabetical (descending)", "descending"],
      ["Statuses posted (lowest first)", "statuses_ascending"],
      ["Statuses posted (highest first)", "statuses_descending"],
      ["Followers count (lowest first)", "followers_ascending"],
      ["Followers count (highest first)", "followers_descending"],
      ["Friends count (lowest first)", "friends_ascending"],
      ["Friends count (highest first)", "friends_descending"],
      ["Friends with but are not following me (ascending)", "friends_not_following_ascending"],
      ["Friends with but are not following me (descending)", "friends_not_following_descending"],
      ["Not friends with but are being followed by (ascending)", "following_not_friends_ascending"],
      ["Not friends with but are being followed by (descending)", "following_not_friends_descending"],
      ["Mutual friends (ascending)", "mutual_friends_ascending"],
      ["Mutual friends (descending)", "mutual_friends_descending"]
    ].unshift(["-- #{label} --", ""])
    
    options_for_select(available, params[:type])
  end
  
  def label_for_sorted_people(type=nil)
    return "recently added" unless type
    
    case type.to_sym
    when :influence_descending
      "Tweasier influence (most influential)"
    when :influence_ascending
      "Tweasier influence (least influential)"
    when :recent
      "recently added"
    when :active
      "active (activity within the last #{Configuration.sorting.inactivity_period} days)"
    when :dormant
      "dormant (no activity in at least #{Configuration.sorting.inactivity_period} days)"
    when :ascending
      "alphabetical (ascending)"
    when :descending
      "alphabetical (descending)"
    when :statuses_ascending
      "statuses count (ascending)"
    when :statuses_descending
      "statuses count (descending)"
    when :followers_ascending
      "followers count (ascending)"
    when :followers_descending
      "followers count (descending)"
    when :friends_ascending
      "friends count (ascending)"
    when :friends_descending
      "friends count (descending)"
    when :friends_not_following_ascending
      "friends with but not being followed (ascending)"
    when :friends_not_following_descending
      "friends with but not being followed (descending)"
    when :following_not_friends_ascending
      "not friends with but are being followed by (ascending)"
    when :following_not_friends_descending
      "not friends with but are being followed by (descending)"
    when :mutual_friends_ascending
      "mutual friends (ascending)"
    when :mutual_friends_descending
      "mutual friends (descending)"
    end
  end
end
