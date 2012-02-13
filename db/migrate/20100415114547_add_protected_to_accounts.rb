class AddProtectedToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :protected, :boolean, :default => false
  end

  def self.down
    remove_column :accounts, :protected
  end
end
