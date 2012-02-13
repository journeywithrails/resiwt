module Tweasier
  module Jobs
    module Scraper
      class HomeTimeline < TweetScraper
        client_method :home_timeline
        resque_queue  :home_timeline
        default_attributes :is_timeline => true  
      end
    end
  end
end
