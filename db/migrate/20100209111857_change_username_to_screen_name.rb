class ChangeUsernameToScreenName < ActiveRecord::Migration
  def self.up
    rename_column :accounts, :username, :screen_name
  end

  def self.down
    rename_column :accounts, :screen_name, :username
  end
end
