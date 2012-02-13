describe UserPresenter do
  
  before :each do
    User.delete_all
    @user      = make_user!
    @presenter = UserPresenter.new(@user)
  end
  
  it "should delegate successfully to the user object" do
    @presenter.id.should            == @user.id
    @presenter.email.should         == @user.email
    @presenter.accounts.size.should == @user.accounts.size
  end
  
end
