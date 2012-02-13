module App
  module Charts
    class UserStatusFrequency < Base
      
      def regenerate!
        values = []
        
        tweets  = self.account.home_timeline.all :limit => 40
        
        grouped = tweets.group_by { |t| t.author.screen_name }
        
        grouped.each do |screen_name, collection|
          values << { :value => collection.size, :label => screen_name }
        end
        
        chart = build_bar_chart(values, "#val# Tweets", "Tweet count")
        
        cache_data(chart.render)
      end
    end
  end
end
