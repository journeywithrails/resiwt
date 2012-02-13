module Tweasier
  module Helpers
    module Influence
      
      def cache_influence_for(account, mash)
        account.influence = generate_influence_for(account, mash)
        account.save
      end
      
      private
      def generate_influence_for(account, mash)
        # (followers / friends) * (amount of statuses * retweets of you).
        followers = mash.followers_count.to_f
        friends   = mash.friends_count.to_f
        followers = 1 unless (followers > 0)
        friends   = 1 unless (friends > 0)
        
        ratio = followers / friends
        
        statuses = mash.statuses_count.to_f
        statuses = 1 unless (statuses > 0)
        
        unless account.new_record?
          retweets = account.retweets_of_me.count.to_f if account.retweets_of_me.present?
          statuses = (statuses * retweets) if retweets.present? && retweets > 0
        end
        
        ratio * statuses
      end
    end
  end
end
