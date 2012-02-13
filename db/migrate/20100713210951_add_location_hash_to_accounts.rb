class AddLocationHashToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :location_hash, :string
  end

  def self.down
    remove_column :accounts, :location_hash
  end
end
