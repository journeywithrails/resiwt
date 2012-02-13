describe ResqueJob do
  
  before(:all) do
    User.delete_all
    App::Account.delete_all
    ResqueJob.delete_all
  end
  
  before(:each) do
    User.delete_all
    App::Account.delete_all
    @job = ResqueJob.make
  end
  
  it "should be valid" do
    @job.should be_valid
  end
  
  it "should ensure that records are unique for record_id, record_type and association" do
    account = App::Account.make
    @job.record_type = "App::Account"
    @job.record_id = account.id
    @job.association = "home_timeline"
    @job.save.should be_true
    
    @other_job = ResqueJob.new
    @other_job.record_type = "App::Account"
    @other_job.record_id = account.id
    @other_job.association = "home_timeline"
    
    @other_job.valid?.should be_false
  end
  
  it "should allow you to access the record from the record accessor" do
    @job.record.should be_instance_of(App::Account)
    @job.record.id.should  == App::Account.first.id
  end
  
end