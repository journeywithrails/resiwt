module Tweasier
  module Jobs
    module Account
      class RefreshMentions < Refresh
        resque_queue :mentions
        association  :mentions
        account_ready_state App::Account::ReadyStates::MENTIONS
        
      end
    end
  end
end
