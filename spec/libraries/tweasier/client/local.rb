# --------------------------------------------------
# Lib Spec: Local
# --------------------------------------------------

module Tweasier::Client
  describe Local do

    before do
      @user    = make_user!
      @account = @user.accounts.first
      @base    = Base.new(@account, "eef8aef6018d69eb772ce1e5edffce9c7f6bc39d82280", "af3a5c541e41670767f63abc524e37e3d48768c153febdcd")
      @local   = Local.new(@base, @account)
    end
    
    after do
      Rails.cache.clear
    end
    
    it "should be delegated to by the client facade" do
      stub_get("/statuses/user_timeline.json", "friends_timeline")
      
      @base.friends_timeline(:page => 1)
    end
    
    it "should successfully cache a key upon initial retrieval" do
      stub_get("/statuses/user_timeline.json", "friends_timeline")
      
      Rails.cache.exist?("#{@local.cache_key_prefix}_friends_timeline_page_1").should be_false
      Rails.cache.read("#{@local.cache_key_prefix}_friends_timeline_page_1").should be_nil
      
      @base.friends_timeline(:page => 1)
      
      Rails.cache.exist?("#{@local.cache_key_prefix}_friends_timeline_page_1").should be_true
      
      result = Rails.cache.read("#{@local.cache_key_prefix}_friends_timeline_page_1")
      result.should_not be_nil
      result.should =~ /Rob Dyrdek is the funniest man alive./
    end
    
    # Check that the local client responds to the correct cache methods
    %w{ friends_timeline
        rate_limit_status
        retweeted_by_me
        retweeted_to_me
        retweets_of_me
        mentions
        direct_messages
        favorites
        user
        user_timeline }.each do |alias_meth|
      it "should alias the ##{alias_meth} method to the local client" do
        @local.should respond_to(alias_meth.to_sym)
      end
    end
  end
end
