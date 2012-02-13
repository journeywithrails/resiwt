class FixIndexesOnStatuses < ActiveRecord::Migration
  def self.up
    add_index :statuses, [:account_id, :twitter_id]
    add_index :statuses, [:account_id, :twitter_id, :tweeted_at]
    #add_index :statuses, [:account_id, :twitter_id, :type]
    
    remove_index :statuses, :type
    remove_index :statuses, :reply_to_author
    remove_index :statuses, :mentioned
    remove_index :statuses, :is_favourite
    remove_index :statuses, :tweeted_at
    remove_index :statuses, :is_timeline
  end

  def self.down
    remove_index :statuses, [:account_id, :twitter_id]
    remove_index :statuses, [:account_id, :twitter_id, :tweeted_at]
    #remove_index :statuses, [:account_id, :twitter_id, :type]

    add_index :statuses, :type
    add_index :statuses, :reply_to_author
    add_index :statuses, :mentioned
    add_index :statuses, :is_favourite
    add_index :statuses, :tweeted_at
    add_index :statuses, :is_timeline
  end
end
