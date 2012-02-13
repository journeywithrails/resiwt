module Tweasier
  module Jobs
    module Scraper
      class TweetScraper < Base
        class << self
          def tweet_class(class_name=nil)
            if class_name 
              write_inheritable_attribute(:tweet_class, class_name)
            else
              read_inheritable_attribute(:tweet_class) || App::Status
            end
          end
          
          def default_attributes(attributes=nil)
            if attributes
              write_inheritable_attribute(:default_attributes, attributes)
            else
              (read_inheritable_attribute(:default_attributes) || {}).symbolize_keys
            end
          end
        end
        
        def before_scrape
          client_args[:page] = page
          client_args[:count] = self.class.tweet_class.per_page
        end
        
        def after_scrape
          # Do something with the data...
          self.input.each do |result|
            status = App::Status.find_or_initialize_by_twitter_id_and_account_id(result.id, record.id)
            status = status.becomes(self.class.tweet_class)
            
            if status.new_record?
              status = status.from_mash(result)
            end
            
            self.class.default_attributes.each_pair do | k, v |
              status[k] = v
            end
            
            status.save!
            
            self.output << status
          end
        end
      end
    end
  end
end