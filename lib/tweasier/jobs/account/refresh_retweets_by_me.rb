module Tweasier
  module Jobs
    module Account
      class RefreshRetweetsByMe < Refresh
        resque_queue :retweets_by_me
        association  :retweets_by_me
        account_ready_state App::Account::ReadyStates::RETWEETS_BY_ME
        
      end
    end
  end
end
