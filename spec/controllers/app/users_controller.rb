describe App::UsersController do
  
  before do
    login!
  end
  
  it "should assign the @user variable on a before filter" do
    get :show
    
    controller.class.before_filters.should include(:get_current_user)
    assigns[:user].accounts.size.should == 1
  end
  
  it "should be able to access a users accounts though the AR association on #show" do
    get :show
    assigns[:user].accounts.should_not be_nil
    assigns[:user].accounts.first.screen_name.should == controller.current_user.accounts.first.screen_name
  end
  
end
