module App
  module Charts
    class RetweetsTimelineRatio < Base
      
      def regenerate!
        values = []
        
        values << { :value => self.account.retweets.size, :label => "Retweets" }
        values << { :value => self.account.home_timeline.size, :label => "Timeline" }
        
        chart = build_pie_chart(values, "#val# Tweets (#percent#)")
        cache_data(chart.render)
      end
    end
  end
end
