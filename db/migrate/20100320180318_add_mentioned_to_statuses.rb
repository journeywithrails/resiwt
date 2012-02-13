class AddMentionedToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :mentioned, :boolean, :default => false
  end

  def self.down
    remove_column :statuses, :mentioned
  end
end
