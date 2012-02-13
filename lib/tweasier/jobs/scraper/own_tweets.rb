module Tweasier
  module Jobs
    module Scraper
      class OwnTweets < TweetScraper
        client_method :user_timeline
        resque_queue  :user_timeline
      end
    end
  end
end