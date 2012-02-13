module Tweasier
  module Jobs
    module Account
      class RefreshRateLimit
        @queue = :refresh_rate_limit

        class << self
          
          def perform(data)
            account = App::Account.find(data["account_id"])
            account.rate_limit = account.limit_information.remaining_hits
            account.save!
            
            if account.rate_limit_hit?
              #HoptoadNotifier.notify(:error_class => Twitter::RateLimitExceeded, :error_message => "Rate limit hit for #{account.screen_name} (#{account.id})")
            end
          end
        end
      end
    end
  end
end
