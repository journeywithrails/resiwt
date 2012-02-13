# --------------------------------------------------
# Controller Spec: App::AccountsController
# --------------------------------------------------

describe App::AccountsController do
  
  before do
    User.delete_all
    login!
  end
  
  it "should get the current account on a before filter" do
    controller.class.before_filters.should include(:get_account)
  end
  
  it "should assign the @statuses variable with a users account statuses" do
    stub_get("/statuses/friends_timeline.json?page=1", "friends_timeline")
    
    get :show, :id => controller.current_user.accounts.first.screen_name
    assigns[:statuses].should_not be_nil
  end
  
end
