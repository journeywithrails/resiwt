class SessionsController < Clearance::SessionsController
  ssl_required :create, :new, :destroy
  ssl_allowed :url_after_destroy
  
end
