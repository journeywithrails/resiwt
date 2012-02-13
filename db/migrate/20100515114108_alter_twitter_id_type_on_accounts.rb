class AlterTwitterIdTypeOnAccounts < ActiveRecord::Migration
  def self.up
    change_column :accounts, :twitter_id, :integer, :null => false
  end

  def self.down
    change_column :accounts, :twitter_id, :string
  end
end
