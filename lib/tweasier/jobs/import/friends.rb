module Tweasier
  module Jobs
    module Import
      class Friends < Base
        relationship_class App::Relationships::Friend
        resque_queue  :import_friends
        client_method :friends
        account_ready_state App::Account::ReadyStates::IMPORT_FRIENDS
        
      end
    end
  end
end
