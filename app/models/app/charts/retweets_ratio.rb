module App
  module Charts
    class RetweetsRatio < Base
      
      def regenerate!
        values = []
        a = self.account
        values << { :value => a.retweets_to_me.nil? ? 0 : a.retweets_to_me.size, :label => "Retweets to me" }
        values << { :value => a.retweets_by_me.nil? ? 0 : a.retweets_by_me.size, :label => "Retweets by me" }
        values << { :value => a.retweets_of_me.nil? ? 0 : a.retweets_of_me.size, :label => "Retweets of me" }
        
        chart = build_pie_chart(values, "#val# Tweets (#percent#)")
        cache_data(chart.render)
      end
      
      def to_csv
        csv_data = generate_csv(["Type", "Count"]) do |row|
          a = self.account
          row << ["Retweets to me", a.retweets_to_me.nil? ? 0 : a.retweets_to_me.size]
          row << ["Retweets by me", a.retweets_by_me.nil? ? 0 : a.retweets_by_me.size]
          row << ["Retweets of me", a.retweets_of_me.nil? ? 0 : a.retweets_of_me.size]
        end
        
        return {:data => csv_data, :headers => csv_headers}
      end
    end
  end
end