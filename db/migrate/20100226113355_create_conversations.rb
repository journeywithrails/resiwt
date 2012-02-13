class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
      t.references :account
      t.string :user_a, :user_b
      t.timestamps
    end
  end

  def self.down
    drop_table :conversations
  end
end
