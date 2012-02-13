module App
  module Charts
    class HourlyStatusFrequency < Base
      
      def regenerate!
        values  = []
        hours   = []
        tweets  = self.account.home_timeline.all(:limit => 1000)
        grouped = tweets.group_by { |t| t.tweeted_at.strftime("%H") }
        grouped.each { |hour, collection| values << { :value => collection.size, :hour => hour } }
        
        (1..24).each do |hour|
          value = 0
          
          values.each do |hash|
            value = hash[:value] if (hash[:hour].to_i == hour)
          end
          
          hours << { :label => ((hour > 12) ? "#{hour - 12}pm" : "#{hour}am"), :value => value }
        end
        
        chart = build_bar_chart(hours.reverse, "#val# tweets", "Hourly frequency")
        cache_data(chart.render)
      end
    end
  end
end
