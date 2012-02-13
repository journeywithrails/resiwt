module Tweasier
  module Jobs
    module Scraper
      class RetweetsOfMe < Base
        client_method :retweets_of_me
        resque_queue  :retweets_of_me
        
        #The retweets of me service returns the users own tweets rather than the retweets. Which is very odd.
        def after_scrape
          
          self.input.each do |result|
            
            retweets = record.client.retweets(result.id)
            
            retweets.each do | retweet |
              status = App::Retweet.find_or_initialize_by_twitter_id_and_account_id(retweet.id, record.id)

              if status.new_record?
                status = status.from_mash(retweet)
                status.save!
              end
              
              self.output << status
            end
          end
        end
      end
    end
  end
end