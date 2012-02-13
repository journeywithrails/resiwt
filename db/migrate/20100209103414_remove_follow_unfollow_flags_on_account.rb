class RemoveFollowUnfollowFlagsOnAccount < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :auto_follow
    remove_column :accounts, :auto_unfollow
  end

  def self.down
    add_column :accounts, :auto_follow, :boolean, :default => true
    add_column :accounts, :auto_unfollow, :boolean, :default => false
  end
end
