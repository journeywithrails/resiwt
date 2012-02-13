class AddIsTimelineToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :is_timeline, :boolean
  end

  def self.down
    remove_column :statuses, :is_timeline
  end
end
