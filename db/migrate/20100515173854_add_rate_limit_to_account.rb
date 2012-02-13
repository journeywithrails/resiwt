class AddRateLimitToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :rate_limit, :integer
  end

  def self.down
    remove_column :accounts, :rate_limit
  end
end
