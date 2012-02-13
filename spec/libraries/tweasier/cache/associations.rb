module Tweasier::Cache
  describe Associations do
     
    before(:all) do
      User.delete_all
      class User::Test < ActiveRecord::Base
        set_table_name "accounts"
      end
      
      class ExampleJob < Tweasier::Jobs::Scraper::Base
        resque_queue :potatoes
        
        def perform(data)
          data.symbolize_keys!
          job = ResqueJob.find data[:job_id]
          job.update_attributes(:refreshed_at => Time.zone.now)
          User::Test.all
        end
      end
      
      User.send :include, Tweasier::Cache::Associations
      User.has_many :tests, :cached_with => ExampleJob, :cached_for => 1.day
    end
    
    before(:each) do
      @user = User.make
    end
    
    it "should attach create helpers on association methods" do
      @user.tests.should respond_to(:stale?)
      @user.tests.should respond_to(:fresh?)
      @user.tests.should respond_to(:refresh)
      @user.tests.cached_for.should == 1.day
      @user.tests.refreshed_at.should == nil
    end
    
    # it "should block whilst updating when using refresh!" do
    #   # TODO: Tom, how to we make this work, alias the client?
    #   @user.tests.should be_empty
    #   
    #   test_object = User::Test.create(:user_id => @user.id)
    #   
    #   @user.tests.refresh!.first.should == test_object
    #   @user.tests.size.should == 1
    #   @user.tests.first.should == test_object
    # end
  end
end
