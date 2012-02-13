module Tweasier
  module Jobs
    module Import
      class FollowerRefresh < RefreshBase
        resque_queue :import_follower_refresh
        import_job_name :import_followers
        job_name :import_follower_refresh
        client_method :follower_ids
        twitter_ids_method :follower_twitter_ids
        account_method :followers
        relationship_class App::Relationships::Follower
        
      end
    end
  end
end
