class ConfirmationsController < Clearance::ConfirmationsController
  include SslRequirement
  
  ssl_required :create, :new
  ssl_allowed :url_after_create
  
  def url_after_create
    app_user_path
  end
  
end
