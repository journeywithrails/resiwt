module Tweasier
  module Authentication
    
    def self.included(base)
      base.send :before_filter, "authenticate_staging"
      #base.send :before_filter, "authenticate_production"
    end
    
    def authenticate_staging
      return true unless Rails.env.staging?
      authenticate_or_request_with_http_basic do |username, password|
        username == Configuration.staging.username && password == Configuration.staging.password
      end
    end
    
    # def authenticate_production
    #   return true unless Rails.env.production?
    #   authenticate_or_request_with_http_basic do |username, password|
    #     username == Configuration.production.username && password == Configuration.production.password
    #   end
    # end
  end
end
