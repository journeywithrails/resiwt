config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true
config.log_level = :debug
config.action_mailer.raise_delivery_errors = true

config.action_mailer.smtp_settings = {
  :address         => "secure.emailsrvr.com",
  :domain          => "mail.tweasier.com",
  :port            => 25,
  :user_name       => "no-reply@mail.tweasier.com",
  :password        => "Brar~pIzert86",
  :authentication  => :login
}

HOST = "staging.tweasier.com"

config.cache_store = :mem_cache_store, "localhost", { :namespace => "staging" }

RSpreedly::Config.setup do |config|
  config.api_key        = "c9f83157e26c79a92d52f0f6b0efb36ae25a35f8"
  config.site_name      = "tweasierstaging"
end
