class CreateCharts < ActiveRecord::Migration
  def self.up
    create_table :charts do |t|
      t.text :data
      t.string :type
      t.timestamps
      t.references :account
    end
  end

  def self.down
    drop_table :charts
  end
end
