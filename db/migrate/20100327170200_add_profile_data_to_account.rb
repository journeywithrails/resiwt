class AddProfileDataToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :name, :string
    add_column :accounts, :description, :string
    add_column :accounts, :url, :string
  end

  def self.down
    remove_column :accounts, :name
    remove_column :accounts, :description
    remove_column :accounts, :url
  end
end
