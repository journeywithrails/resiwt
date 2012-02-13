require 'twitter'
class ApplicationController < ActionController::Base
  include Clearance::Authentication
  include Tweasier::Authentication
  include Tweasier::Helpers
  include SslRequirement
  include ExceptionNotification::Notifiable
  
  helper :all
  helper_method :should_be_ssl?
  
  filter_parameter_logging :password, :password_confirmation
  protect_from_forgery

  def subscription_plans
    @subscription_plans ||= Payment::Plan.all
  end
  helper_method :subscription_plans
  
  protected
  
  def ssl_required?
    if Rails.env =~ /development|staging/
      @should_be_ssl = super
      false
    else
      super
    end
  end
  
  def should_be_ssl?
    @should_be_ssl || false
  end
  
  def render_error(code)
    redirect_to "/#{code.to_s}.html"
  end
  
  def sign_in(user)
    user.refresh_accounts!
    user.refresh_subscription!
    super(user)
  end
  
  rescue_from CanCan::AccessDenied do |ex|
    flash[:error] = ex.message
    redirect_to upgrade_app_user_subscription_path
  end
  
  rescue_from ActionController::Forbidden do |ex|
    flash[:error] = ex.message
    redirect_to root_url
  end
  
end
