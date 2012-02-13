require 'machinist/active_record'
require 'sham'
require 'faker'

module App

  Conversation.blueprint do
    account { Account.make }
    user_a { "bob" }
    user_b { "billy" }
  end
  
end
