module Tweasier
  module Jobs
    module Scraper
      class DirectMessages < Base
        client_method :direct_messages
        resque_queue  :direct_messages
        
        def after_scrape
          self.input.each do |dm|
            status = App::Status.find_or_initialize_by_twitter_id_and_account_id(dm.id, record.id)
            status = status.from_mash(Hashie::Mash.new(:text => dm.text, :created_at => dm.created_at, :user => dm.sender)) if status.new_record?

            unless status.class == App::DirectMessage
              status      = status.becomes(App::DirectMessage)
              status.type = App::DirectMessage.to_s
              status.save!
            end
            
            self.output << status
         end
       end
      end
    end
  end
end
