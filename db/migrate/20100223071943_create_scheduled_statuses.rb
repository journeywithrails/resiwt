class CreateScheduledStatuses < ActiveRecord::Migration
  def self.up
    create_table :scheduled_statuses do |t|
      t.references :account
      t.text :text, :limit => "140"
      t.datetime :publish_date
      t.boolean :published, :default => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :scheduled_statuses
  end
end
