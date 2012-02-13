class AddObjectCreatedAtToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :object_created_at, :datetime
  end

  def self.down
    remove_column :events, :object_created_at
  end
end
