module App
  describe Conversation do
    before do
      User.delete_all
      
      @account = Account.make
      @account.conversations.delete_all
      @conversation = @account.conversations.make
    end
    
    it "should have the correct associations setup" do
      @conversation.should belong_to(:account)
    end
    
    it "should have the correct validations setup" do
      @conversation.should validate_presence_of(:account)
    end
    
    it "should validate the uniqueness of a conversation" do
      conversation = @account.conversations.build(:user_a => @conversation.user_a, :user_b => @conversation.user_b)
      
      conversation.valid?.should == false
      conversation.errors.size.should >= 1
      conversation.user_a = Sham.name
      conversation.user_b = Sham.name
      conversation.valid?.should == true
      conversation.errors.should be_empty
    end
    
    it "should validate two people being present in the conversation" do
      conversation = @account.conversations.build(:user_a => Sham.name)
      
      conversation.valid?.should == false
      conversation.errors.size.should >= 1
      conversation.user_b = Sham.name
      conversation.valid?.should == true
      conversation.errors.should be_empty
    end
    
  end
end
