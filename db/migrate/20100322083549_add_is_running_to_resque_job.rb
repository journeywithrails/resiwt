class AddIsRunningToResqueJob < ActiveRecord::Migration
  def self.up
    add_column :resque_jobs, :is_running, :boolean
  end

  def self.down
    remove_column :resque_jobs, :is_running
  end
end
