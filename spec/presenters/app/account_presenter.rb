module App
  describe AccountPresenter do
    
    before :each do
      User.delete_all
      @user      = make_user!
      @account   = @user.accounts.first
      @presenter = AccountPresenter.new(@account)
    end
    
    it "should return the screen name on #to_param" do
      @presenter.to_param.should == @account.screen_name
    end
    
    it "should delegate successfully to the account object" do
      @presenter.id.should            == @account.id
      @presenter.screen_name.should   == @account.screen_name
    end
  end
end
