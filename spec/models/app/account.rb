# --------------------------------------------------
# Model Spec: Account
# --------------------------------------------------

module App
  describe Account do

    before(:all) do
      User.delete_all
      Account.delete_all
    end

    before(:each) do
      user = make_user!
      @account = user.accounts.first
    end
    
    it "should be valid" do
      @account.should be_valid
    end

    it "should belong to user" do
      @account.should belong_to(:user)
    end
    
    it "should have many searches" do
      @account.should have_many(:searches)
    end
    
    it "should have many links" do
      @account.should have_many(:links)
    end
    
    it "should have many friends and followers" do
      @account.should have_many(:friends)
      @account.should have_many(:followers)
    end
    
    it "should respond to friendly ID" do
      @account.should respond_to(:friendly_id)
    end
    
    it "should have the daily_digest named scope setup" do
      Account.should respond_to(:daily_digest)
    end
    
    it "should have the weekly_digest named scope setup" do
      Account.should respond_to(:weekly_digest)
    end
    
    
    it "should delegate the relevant oauth methods to the oauth client" do
      @account.should respond_to(:request_token)
      @account.should respond_to(:access_token)
      @account.should respond_to(:authorize_from_request)
    end
    
    it "should have the email notification constants defined" do
      Account::EMAIL_NOTIFICATIONS_DAILY.should_not be_nil
      Account::EMAIL_NOTIFICATIONS_WEEKLY.should_not be_nil
      Account::EMAIL_NOTIFICATIONS_OFF.should_not be_nil
      
      Account::EMAIL_NOTIFICATIONS_DAILY.should  == "daily"
      Account::EMAIL_NOTIFICATIONS_WEEKLY.should == "weekly"
      Account::EMAIL_NOTIFICATIONS_OFF.should    == "none"
    end
    
    it "should recognise a different object when comparing through #is_twitter_user?" do
      stub_get("/users/show/random.json", "user")
      
      other_person = @account.client.user("random")
      
      @account.is_twitter_user?(other_person).should be_false
    end
    
    it "should be authorised with access token and secret present" do
      @account.authorized?.should be_true
    end
    
    it "should not be authorised without access token and secret present" do
      @account.atoken  = ""
      @account.asecret = ""
      @account.save
      
      @account.authorized?.should be_false
    end
    
    it "should present a valid Tweasier::Client::Base object when calling #client" do
      @account.client.should be_an_instance_of(Tweasier::Client::Base)
    end
    
    it "should have the correct resque queue setup for daily/weekly email digests" do
      @account.should respond_to(:queue_daily_digest_mail!)
      @account.should respond_to(:queue_weekly_digest_mail!)
    end
    
    it "should have the follow limit exceeded job setup" do
      @account.should respond_to(:queue_follow_limit_exceeded_mail!)
    end
    
    it "should have then email_notifications preference column" do
      @account.should respond_to(:email_notifications)
      @account.email_notifications.should_not be_nil
    end
    
    it "should allow bitly preferences to be assigned to it" do
      @account.should respond_to(:bitly_token)
      @account.should respond_to(:bitly_secret)
      
      @account.bitly_token  = "sometoken"
      @account.bitly_secret = "somesecret"
      
      @account.save
      @account.reload
      
      @account.bitly_token.should  == "sometoken"
      @account.bitly_secret.should == "somesecret"
    end
    
    it "should mark the account as #link_shortening_available? upon valid information" do
      @account.bitly_token  = ""
      @account.bitly_secret = ""
      
      @account.should_not be_link_shortening_available
      
      @account.bitly_token  = "sometoken"
      @account.bitly_secret = "somesecret"
      
      @account.should be_link_shortening_available
    end
    
    it "should reset the stored bitly credentials on #reset_bitly_credentials!" do
      @account.bitly_token  = "sometoken"
      @account.bitly_secret = "somesecret"
      
      @account.save
      
      @account.bitly_token.should  == "sometoken"
      @account.bitly_secret.should == "somesecret"
      
      @account.reset_bitly_credentials!
      
      @account.bitly_token.should be_nil
      @account.bitly_secret.should be_nil
    end
  end
end
