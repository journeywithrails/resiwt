class AddReadyStateToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :ready_state, :integer, :default => 0
  end

  def self.down
    remove_column :accounts, :ready_state
  end
end
