class AddTweetedAtToStatus < ActiveRecord::Migration
  def self.up
    add_column :statuses, :tweeted_at, :datetime
  end

  def self.down
    remove_column :statuses, :tweeted_at
  end
end
