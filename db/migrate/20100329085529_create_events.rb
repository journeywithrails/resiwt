class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :object_id
      t.string  :object_type
      t.references :account
    end
  end
  
  def self.down
    drop_table :events
  end
end
