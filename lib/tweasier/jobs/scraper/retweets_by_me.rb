module Tweasier
  module Jobs
    module Scraper
      class RetweetsByMe < TweetScraper
        client_method :retweeted_by_me
        resque_queue  :retweeted_by_me
        tweet_class App::Retweet
      end
    end
  end
end