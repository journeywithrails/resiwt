class AddDefaultToEventNotifications < ActiveRecord::Migration
  def self.up
    change_column :accounts, :event_notifications, :boolean, :default => false
  end

  def self.down
    change_column :accounts, :event_notifications, :boolean
  end
end
