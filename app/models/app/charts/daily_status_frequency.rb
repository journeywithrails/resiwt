module App
  module Charts
    class DailyStatusFrequency < Base
      
      def regenerate!
        values = []
        
        tweets  = self.account.home_timeline.all :limit => 200
        
        grouped = tweets.group_by { |t| t.tweeted_at.beginning_of_day }
        
        grouped.each do |day, collection|
          values << { :value => collection.size, :label => day }
        end
        
        chart = build_bar_chart(values, "#val# Tweets", "Tweet count")
        
        cache_data(chart.render)
      end
    end
  end
end
