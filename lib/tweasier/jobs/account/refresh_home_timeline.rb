module Tweasier
  module Jobs
    module Account
      class RefreshHomeTimeline < Refresh
        resque_queue :home_timeline
        association  :home_timeline
        account_ready_state App::Account::ReadyStates::HOME_TIMELINE
        
      end
    end
  end
end
