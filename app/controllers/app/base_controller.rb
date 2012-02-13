module App
  class BaseController < ApplicationController
    include Tweasier::Helpers::Influence
    include Utils
    
    helper_method :generate_influence_for
    
    before_filter :authenticate
    
    before_filter :get_current_user,
                  :validate_subscription,
                  :get_account,
                  :set_application_context,
                  :assign_default_params,
                  :get_poll,
                  :get_feedback_entry
    
    alias_method :open_flash_chart_2, :ofc2
    helper_method :open_flash_chart_2
    
    rescue_from(Twitter::Unauthorized) do |exception|
      reset_session
      flash[:error] = 'Sorry, there was a problem authenticating your account for that request.'
      redirect_to app_user_path
    end
    
    rescue_from(Errno::ECONNRESET, Twitter::Unavailable) do |exception|
      flash[:error] = 'Sorry, twitter appears to be unavailable at this time.'
      redirect_to app_user_path
    end
    
    rescue_from(Twitter::RateLimitExceeded) do |exception|
      message = "Sorry, you have exceeded your quota for this hour. You will be able to make requests again shortly. Thank you for your patience."
      
      if request.xhr?
        render :text => "<div class=\"flash failure\">#{message}</div>"
      else
        flash[:failure] = message
        redirect_to app_user_path
      end
    end
    
    rescue_from(Twitter::General) do |exception|
      case exception.data["error"]
      when /You are unable to follow more people at this time/
        @account.queue_follow_limit_exceeded_mail!
      else
        flash[:error] = exception.message
        redirect_to app_user_path
      end
    end
    
    protected
    def get_current_user
      @user ||= presenter_for(current_user) if current_user
    end
    
    def validate_subscription
      unless @user.active?
        return if controller_name == "subscriptions"
        flash[:failure] = "Please complete your subscription information before continuing."
        redirect_to new_app_user_subscription_path
      end
    end
    
    def get_account
      return unless @user and params[:account_id]
      @account ||= presenter_for(@user.accounts.find_by_screen_name(params[:account_id]))
    end
    
    def get_poll
      @poll ||= Feedback::Poll.random(@user)
    end
    
    def get_feedback_entry
      @feedback_entry ||= Feedback::FeedbackEntry.new
    end
    
    def assign_default_params
      params[:page]   ||= "1"
      params[:cursor] ||= "-1"
    end
    
    def set_application_context
      @within_application = true
    end
  end
end
