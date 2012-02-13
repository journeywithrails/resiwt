class AddPageToResqueJobs < ActiveRecord::Migration
  def self.up
    add_column :resque_jobs, :page, :integer, :default => 1
    remove_index :resque_jobs, :name => :job_record_index
    add_index(:resque_jobs, [:record_type, :record_id, :association, :page], {:unique => true, :name => 'job_record_index'})
    ResqueJob.update_all(:page => 1)
  end

  def self.down
    remove_column :resque_jobs, :page
    remove_index :resque_jobs, :name => :job_record_index
    add_index(:resque_jobs, [:record_type, :record_id, :association], {:unique => true, :name => 'job_record_index'})
  end
end
