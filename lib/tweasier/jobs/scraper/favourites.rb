module Tweasier
  module Jobs
    module Scraper
      class Favourites < TweetScraper
        client_method :favorites
        resque_queue  :favourites
        default_attributes :favourite => true
      end
    end
  end
end