require 'machinist/active_record'
require 'sham'
require 'faker'
require 'ostruct'

# TODO: test properly - stubbing out payment methods for now
class User
  def setup_payment!; true; end
  def cancel_subscription!; true; end
  def subscriber!; OpenStruct.new ; end
  
  def sign_user_in; true; end
end

User.blueprint do
  email { Sham.email }
  password { "password" }
  plan_id { 1 }
  feature_level { "free" }
  bypass_invite { true }
  #invitation { App::Invitation.make }
end

User.blueprint(:paid) do
  email { "admin" + Sham.email }
  password { "password" }
  plan_id { 2 }
  feature_level { "paid" }
  bypass_invite { true }
  #invitation { App::Invitation.make }
end
