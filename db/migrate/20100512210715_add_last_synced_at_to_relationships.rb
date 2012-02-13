class AddLastSyncedAtToRelationships < ActiveRecord::Migration
  def self.up
    add_column :relationships, :last_synced_at, :datetime
  end

  def self.down
    remove_column :relationships, :last_synced_at
  end
end
