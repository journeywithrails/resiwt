class UsersController < Clearance::UsersController
  ssl_required :create, :new, :edit, :update, :beta_signup, :show
  
  before_filter :get_plans, :only => [ :new, :create, :beta_signup ]
  
  def beta_signup
    @user = User.new(:invitation_token => params[:invitation_token])
    @user.email = @user.invitation.recipient_email if @user.invitation
  end
  
  protected
    def get_plans
      @plans = Payment::Plan.all
    end
  
end
