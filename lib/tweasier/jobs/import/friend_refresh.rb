module Tweasier
  module Jobs
    module Import
      class FriendRefresh < RefreshBase
        resque_queue :import_friend_refresh
        job_name :import_friend_refresh
        import_job_name :import_friends
        client_method :friend_ids
        twitter_ids_method :friend_twitter_ids
        account_method :friends
        relationship_class App::Relationships::Friend
        
      end
    end
  end
end
