class PasswordsController < Clearance::PasswordsController
  ssl_required :create, :new, :edit, :update
  ssl_allowed :url_after_update
  
  
end
