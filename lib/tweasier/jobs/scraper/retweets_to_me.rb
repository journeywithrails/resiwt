module Tweasier
  module Jobs
    module Scraper
      class RetweetsToMe < TweetScraper
        client_method :retweeted_to_me
        resque_queue  :retweeted_to_me
        tweet_class App::Retweet
      end
    end
  end
end