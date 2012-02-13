class AddTwitterIdToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :twitter_id, :string
  end

  def self.down
    remove_column :accounts, :twitter_id
  end
end
