module App
  class SubscriptionsController < BaseController
    before_filter :check_for_existing_subscription, :only => [:new, :create]
    
    def show
      @user.refresh_subscription!
      @subscription = @user.subscriber
    end
    
    def new
      @within_application = false
    end
    
    def create
      @invoice = @user.setup_card_details(params[:credit_card])
      
      if @invoice.errors.empty?
        flash[:success] = "Thanks for signing up to Tweasier!"
        redirect_to app_user_path
      else
        @within_application = false
        flash[:failure] = "Sorry we could not process your order, please check the information you entered and try again."
        render :new
      end
    end
    
    def upgrade
      @user.refresh_subscription!
      @subscription = @user.subscriber
      if @subscription.feature_level == 'paid'
        flash[:notice] = "You don't need to upgrade you are already using a Tweasier Pro account"
        redirect_to app_home_path
      end
    end
    
    private
      def check_for_existing_subscription
        if @user.active?
          flash[:failure] = "You have already subscribed to Tweasier!"
          redirect_to app_home_path
        end
      end
  end
end
