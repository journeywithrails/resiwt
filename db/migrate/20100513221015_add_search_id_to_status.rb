class AddSearchIdToStatus < ActiveRecord::Migration
  def self.up
    add_column :statuses, :search_id, :integer
  end

  def self.down
    remove_column :statuses, :search_id
  end
end
