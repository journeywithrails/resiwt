class CreateAppStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.integer :account_id
      t.integer :author_id
      t.integer :reply_to_id
      t.integer :retweet_id
      t.text :message
      t.string :source, :default => "web"
      t.boolean :favourite, :default => false
      t.string :coordinates
      t.string :twitter_id
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
  end
end
