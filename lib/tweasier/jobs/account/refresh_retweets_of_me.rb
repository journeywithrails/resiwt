module Tweasier
  module Jobs
    module Account
      class RefreshRetweetsOfMe < Refresh
        resque_queue :retweets_of_me
        association  :retweets_of_me
        account_ready_state App::Account::ReadyStates::RETWEETS_OF_ME
        
      end
    end
  end
end
