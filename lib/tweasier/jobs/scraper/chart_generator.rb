module Tweasier
  module Jobs
    module Scraper
      class ChartGenerator < Base
        resque_queue :chart_generator
        
        def scrape!          
          klass = "App::Charts::#{association.classify.gsub("Chart", "")}".constantize
          chart = klass.create(:account_id => record.id) if record.send(association).nil? || record.send(association).is_a?(Tweasier::Cache::NilCacheObject)
          
          record.reload
          
          record.send(association).regenerate!
          
          self.output = record.send(association)
        end
      end
    end
  end
end
