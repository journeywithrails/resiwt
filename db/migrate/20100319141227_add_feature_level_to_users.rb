class AddFeatureLevelToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :feature_level, :string
    add_column :users, :plan_id, :integer
  end

  def self.down
    remove_column :users, :feature_level
    remove_column :users, :plan_id
  end
end
