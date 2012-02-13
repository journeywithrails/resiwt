require 'machinist/active_record'
require 'sham'
require 'faker'

module App

  ScheduledStatus.blueprint do
    account { Account.make }
    text { Sham.name }
    publish_date { "2011-06-22 17:05:00" }
    published { false }
  end
  
end
