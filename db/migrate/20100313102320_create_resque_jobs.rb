class CreateResqueJobs < ActiveRecord::Migration
  def self.up
    create_table :resque_jobs do |t|
      t.string :record_type
      t.integer :record_id
      t.string :association
      t.datetime :refreshed_at
      t.timestamps
    end
    add_index(:resque_jobs, [:record_type, :record_id, :association], {:unique => true, :name => 'job_record_index'})
  end

  def self.down
    drop_table :resque_jobs
  end
end
