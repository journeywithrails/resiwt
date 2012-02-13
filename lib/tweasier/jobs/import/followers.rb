module Tweasier
  module Jobs
    module Import
      class Followers < Base
        relationship_class App::Relationships::Follower
        resque_queue  :import_followers
        client_method :followers
        account_ready_state App::Account::ReadyStates::IMPORT_FOLLOWERS
        
      end
    end
  end
end
