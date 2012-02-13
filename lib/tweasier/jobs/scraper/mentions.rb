module Tweasier
  module Jobs
    module Scraper
      class Mentions < TweetScraper
        client_method :mentions
        resque_queue  :mentions
        default_attributes :mentioned => true
      end
    end
  end
end
