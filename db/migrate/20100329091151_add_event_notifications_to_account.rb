class AddEventNotificationsToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :event_notifications, :boolean, :default => true
  end

  def self.down
    remove_column :accounts, :email_notifications
  end
end
