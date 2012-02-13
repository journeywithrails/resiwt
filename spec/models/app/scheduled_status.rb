# --------------------------------------------------
# Model Spec: Scheduled Status
# --------------------------------------------------

module App
  describe ScheduledStatus do
    before do
      User.delete_all
      Account.delete_all
      
      @account = Account.make
      @account.scheduled_statuses.delete_all
      @scheduled_status = @account.scheduled_statuses.make
    end
    
    it "should have the correct associations setup" do
      @scheduled_status.should belong_to(:account)
    end
    
    it "should have the correct validations setup" do
      @scheduled_status.should validate_presence_of(:account)
      @scheduled_status.should validate_presence_of(:text)
      @scheduled_status.should validate_length_of(:text, :maximum => 140)
      @scheduled_status.should validate_presence_of(:publish_date)
    end
    
    it "should validate a date being in the past" do
      @scheduled_status.publish_date  = "2009-06-22 17:05:00"
      @scheduled_status.valid?.should == false
      @scheduled_status.publish_date  = "2019-06-22 17:05:00"
      @scheduled_status.valid?.should == true
    end
    
    it "should validate two updates being scheduled around the same time" do
      scheduled_status = @account.scheduled_statuses.build
      scheduled_status.text = "Hello world!"
      scheduled_status.publish_date = @scheduled_status.publish_date
      
      ScheduledStatus::VALIDATION_TIME_GAP.should == 10
      
      scheduled_status.valid?.should == false
      scheduled_status.errors.size.should >= 1
    end
  end
end
