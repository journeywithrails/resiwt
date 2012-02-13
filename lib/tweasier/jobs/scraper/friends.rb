module Tweasier
  module Jobs
    module Scraper
      class Friends < RelationshipScraper
        client_method :friends
        resque_queue  :friends
        relationship_class App::Relationships::Friend
      end
    end
  end
end