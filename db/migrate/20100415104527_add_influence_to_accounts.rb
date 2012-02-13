class AddInfluenceToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :influence, :float, :default => 0
  end

  def self.down
    remove_column :accounts, :float
  end
end
