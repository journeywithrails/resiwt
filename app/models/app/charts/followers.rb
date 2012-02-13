require 'csv'
module App
  module Charts
    class Followers < Base
      
      def regenerate!
        followers = self.account.followers.recent.group_by { |p| p.timestamp.beginning_of_month.to_s(:month) }
        
        values = []
        
        followers.each do |month, collection|
          values << { :value => collection.size, :label => month }
        end
        
        chart = build_line_chart(values, "#val# people", "followers count")
        
        cache_data(chart.render)
      end
      
      def to_csv
        friends = self.account.followers
        
        csv_data = generate_csv(["Name", "Screen name", "Location", "Status updates", "Friends count", "Followers count"]) do |row|
          friends.each do |friend|
            row << [friend.name, friend.screen_name, friend.location, friend.statuses_count, friend.friends_count, friend.followers_count]
          end
        end
        
        return {:data => csv_data, :headers => csv_headers}
      end
    end
  end
end
