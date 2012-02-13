require 'machinist/active_record'
require 'sham'
require 'faker'

module App
  
  Invitation.blueprint do
    recipient_email { Sham.email }
    sender { User.find_by_email('admin@tweasier.com') || User.make(:email => 'admin@tweasier.com',:invitation => nil) }
  end
  
end
