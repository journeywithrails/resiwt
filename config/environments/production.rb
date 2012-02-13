config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

config.action_mailer.smtp_settings = {
  :address         => "secure.emailsrvr.com",
  :domain          => "mail.tweasier.com",
  :port            => 25,
  :user_name       => "no-reply@mail.tweasier.com",
  :password        => "Brar~pIzert86",
  :authentication  => :login
}

HOST = "tweasier.com"

config.action_controller.asset_host = Proc.new { |source, request|
    if request.ssl?
      "#{request.protocol}#{request.host_with_port}"
    else
      "#{request.protocol}www#{rand(4)}.#{HOST}"
    end
  }

config.cache_store = :mem_cache_store, "localhost", { :namespace => "production" }

RSpreedly::Config.setup do |config|
  config.api_key        = "fefa54558a6418e582b6afefd4121026a80ec971"
  config.site_name      = "tweasierproduction"
end
