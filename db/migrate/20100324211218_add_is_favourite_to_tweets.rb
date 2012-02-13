class AddIsFavouriteToTweets < ActiveRecord::Migration
  def self.up
    add_column :statuses, :is_favourite, :boolean, :default => false
  end

  def self.down
    remove_column :statuses, :is_favourite
  end
end
