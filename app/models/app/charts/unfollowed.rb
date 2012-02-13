require 'csv'
module App
  module Charts
    class Unfollowed < Base
      
      def regenerate!
        people = self.account.unfollowed.recent.reverse.group_by { |p| p.timestamp.beginning_of_month.to_s(:month) }
        
        values = []
        
        people.each do |month, collection|
          values << { :value => collection.size, :label => month }
        end
        
        chart = build_line_chart(values, "#val# people", "unfollowed count")
        
        cache_data(chart.render)
      end
      
      def to_csv
        unfollowed = self.account.unfollowed
        
        csv_data = generate_csv(["Name", "Screen name", "Location", "Status updates", "Friends count", "Followers count"]) do |row|
          unfollowed.each do |person|
            row << [person.name, person.screen_name, person.location, person.statuses_count, person.friends_count, person.followers_count]
          end
        end
        
        return {:data => csv_data, :headers => csv_headers}
      end
    end
  end
end
