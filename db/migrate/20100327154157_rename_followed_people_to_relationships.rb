class RenameFollowedPeopleToRelationships < ActiveRecord::Migration
  def self.up
    rename_table :follower_people, :relationships
    remove_column :relationships, :user
    rename_column :relationships, :account_id, :from_account_id
    add_column :relationships, :to_account_id, :integer
  end

  def self.down
    rename_table :relationships, :follower_people
    add_column :follower_people, :user, :text
    rename_column :relationships, :from_account_id, :account_id
    remove_column :relationships, :to_account_id
  end
end
