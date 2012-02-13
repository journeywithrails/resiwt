class AddToAccountIdAndTypeIndexToRelationships < ActiveRecord::Migration
  def self.up
    add_index :relationships, [:to_account_id, :type]
    
    remove_index :relationships, :statuses_count
    remove_index :relationships, :followers_count
    remove_index :relationships, :friends_count
    remove_index :relationships, :type
  end

  def self.down
    remove_index :relationships, [:to_account_id, :type]
    
    add_index :relationships, :statuses_count
    add_index :relationships, :followers_count
    add_index :relationships, :friends_count
    add_index :relationships, :type
  end
end
