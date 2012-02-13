User.all.each do |u|
  u.accounts.each do |a|
    unless a.in_ready_state?
      friends_job = ResqueJob.find_or_create_by_association_and_record_id(:association => "import_friends", :record_type => a.class.to_s, :record_id => a.id, :is_running => true)
      follower_job = ResqueJob.find_or_create_by_association_and_record_id(:assocation => "import_followers", :record_type => a.class.to_s, :record_id => a.id, :is_running => true)
      Resque.enqueue(Tweasier::Jobs::Import::Friends, :job_id => friends_job.id, :account_id => a.id)
      Resque.enqueue(Tweasier::Jobs::Import::Followers, :job_id => follower_job.id, :account_id => a.id)
    end
  end
end