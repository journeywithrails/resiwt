# --------------------------------------------------
# Model Spec: Search
# --------------------------------------------------

module App
  describe Search do

    before(:all) do
      User.delete_all
      Account.delete_all
    end

    before(:each) do
      user = make_user!
      @account = user.accounts.first
      @search  = @account.searches.first
    end

    it "should belong to an account" do
      @search.should belong_to(:account)
    end

    it "should have many conditions" do
      @search.should have_many(:conditions)
    end

    it "should have many followed and unfollowed people" do
      @search.should have_many(:friends)
      @search.should have_many(:unfollowed)
    end

    it "should validate presence of account and title" do
      @search.should validate_presence_of(:account)
      @search.should validate_presence_of(:title)
    end

    it "should return a blank string on #parameterize when no conditions are present" do
      @search.parameterize.should == ""
    end

    it "should be able to parameterise a string of conditions" do
      @search.conditions << SearchCondition.make(:value => "bob")
      @search.conditions << SearchCondition.make(:value => "timmy")
      @search.conditions << SearchCondition.make(:value => "sandy")
      @search.parameterize.should == "-bob -timmy -sandy"
    end
  end
end
