module Tweasier
  module Jobs
    module Account
      class RefreshRetweetsToMe < Refresh
        resque_queue :retweets_to_me
        association  :retweets_to_me
        account_ready_state App::Account::ReadyStates::RETWEETS_TO_ME
        
      end
    end
  end
end
