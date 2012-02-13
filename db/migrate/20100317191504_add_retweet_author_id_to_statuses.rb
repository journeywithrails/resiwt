class AddRetweetAuthorIdToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :retweet_author_id, :integer
  end

  def self.down
    remove_column :statusues, :retweet_author_id
  end
end
