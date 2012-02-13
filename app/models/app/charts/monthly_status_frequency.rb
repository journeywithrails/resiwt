module App
  module Charts
    class MonthlyStatusFrequency < Base
      
      def regenerate!
        values = []
        
        tweets  = self.account.home_timeline.all :limit => 2000
        
        grouped = tweets.group_by { |t| t.tweeted_at.beginning_of_month }
        
        grouped.each do |day, collection|
          values << { :value => collection.size, :label => "M/C #{day}" }
        end
        
        chart = build_bar_chart(values, "#val# Tweets", "Tweet count")
        
        cache_data(chart.render)
      end
    end
  end
end
