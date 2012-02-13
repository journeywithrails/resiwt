config.cache_classes = true
config.whiny_nils = true
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true
config.action_controller.allow_forgery_protection = false
config.action_mailer.delivery_method = :test

config.gem 'rspec'
config.gem 'rspec-rails'
config.gem 'notahat-machinist', :lib => 'machinist'
config.gem 'faker'
config.gem 'fakeweb'
config.gem 'cucumber-rails',    :lib => 'cucumber'
config.gem 'pickle'

HOST = 'localhost'

config.cache_store = :file_store, "#{Rails.root}/tmp/test_cache/"

RSpreedly::Config.setup do |config|
  config.api_key        = "4fec95a2fd5a19ce950b4f992241cb12a052c1a9"
  config.site_name      = "tweasierdevelopment"
end
