module Tweasier
  module Jobs
    module Scraper
      class Followers < RelationshipScraper
        client_method :followers
        resque_queue  :followers
        relationship_class App::Relationships::Follower
      end
    end
  end
end