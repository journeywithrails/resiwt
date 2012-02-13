module Tweasier
  module Jobs
    module Account
      class RefreshDirectMessages < Refresh
        resque_queue :direct_messages
        association  :direct_messages
        account_ready_state App::Account::ReadyStates::DIRECT_MESSAGES
        
      end
    end
  end
end
