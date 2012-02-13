module Payment
  class Plan
    class << self
      CACHE_KEY = "subscription_plans"
      
      def find id
        RSpreedly::SubscriptionPlan.find(id)
      end
      
      def all
        get_or_set_plans || []
      end
      
      def expire_cache!
        Tweasier::Cache::Base.expire!(CACHE_KEY) if Tweasier::Cache::Base.exists?(CACHE_KEY)
      end
      
      private
      def get_or_set_plans
        if Tweasier::Cache::Base.exists?(CACHE_KEY)
          Tweasier::Cache::Base.get(CACHE_KEY)
        else
          plans = RSpreedly::SubscriptionPlan.active
          Tweasier::Cache::Base.set(CACHE_KEY, plans)
          plans
        end
      end
    end
  end
end
