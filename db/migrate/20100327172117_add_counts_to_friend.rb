class AddCountsToFriend < ActiveRecord::Migration
  def self.up
    add_column :relationships, :statuses_count, :integer
    add_column :relationships, :followers_count, :integer
    add_column :relationships, :friends_count, :integer
  end

  def self.down
    remove_column :relationships, :statuses_count
    remove_column :relationships, :followers_count
    remove_column :relationships, :friends_count
  end
end
