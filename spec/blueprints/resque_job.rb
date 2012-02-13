require 'machinist/active_record'
require 'sham'
require 'faker'

ResqueJob.blueprint do
  record_type { "App::Account" }
  record_id { App::Account.make.id }
  association { "home_timeline" }
end