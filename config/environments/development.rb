ENV["RAILS_ASSET_ID"] = 'dev'

config.cache_classes = false
config.whiny_nils = true
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = true
config.action_mailer.raise_delivery_errors = false

HOST = 'tweasier.local'

config.gem 'capistrano'
#config.gem 'ruby-debug19', :lib => 'ruby-debug'

config.cache_store = :file_store, "#{Rails.root}/tmp/cache/"

RSpreedly::Config.setup do |config|
  config.api_key        = "4fec95a2fd5a19ce950b4f992241cb12a052c1a9"
  config.site_name      = "tweasierdevelopment"
end