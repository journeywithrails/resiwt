class AddProfileImageUrlToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :profile_image_url, :string, :default => 'blank.png'
  end

  def self.down
    remove_column :accounts, :profile_image_url
  end
end
