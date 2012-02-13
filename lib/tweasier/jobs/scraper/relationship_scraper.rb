module Tweasier
  module Jobs
    module Scraper
      class RelationshipScraper < Base
        class << self
          def relationship_class(class_name=nil)
            if class_name 
              write_inheritable_attribute(:relationship_class, class_name)
            else
              read_inheritable_attribute(:relationship_class) || App::Relationships::Person
            end
          end
        end
        
        def after_scrape
          self.output = self.input.collect do | user |
            next unless user.is_a?(Hashie::Mash)
            
            account = App::Account.first(:conditions => ["twitter_id = ? or screen_name = ?", user.id, user.screen_name])
            account = App::Account.new if account.nil?
            
            account.from_mash!(user)
            account.save!
            
            friend = self.class.relationship_class.find_or_initialize_by_from_account_id_and_to_account_id(record.id, account.id)
            friend.mutual_follow = (user.following == "true")
            friend.statuses_count = user.statuses_count
            friend.followers_count = user.followers_count
            friend.friends_count = user.friends_count
            friend.mutual_follow = user.following
            friend.save!
            
            friend
          end
        end
      end
    end
  end
end
