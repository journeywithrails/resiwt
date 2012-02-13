module Tweasier
  module Jobs
    module Account
      class RefreshFavourites < Refresh
        resque_queue :favourites
        association  :favourites
        account_ready_state App::Account::ReadyStates::FAVOURITES
        
      end
    end
  end
end
