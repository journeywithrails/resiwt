class AddTwitterCreatedAtToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :twitter_created_at, :datetime
  end

  def self.down
    add_column :accounts, :twitter_created_at, :datetime
  end
end
