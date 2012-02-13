module App
  module Charts
    class SearchesUnfollowed < Base
      
      def regenerate!
        values = []
        
        self.account.searches.each do |search|
          values << {:value => search.unfollowed.count, :label => "#{search.title} (#{search.unfollowed.count} people)" }
        end
        
        unaccountable = self.account.unfollowed.count({:conditions => ['search_id IS NULL']})
        
        values << { :value => unaccountable, :label => "Unaccountable (#{unaccountable} people)" }
        chart = build_bar_chart(values, "#val# people", "unfollowed users")
        
        cache_data(chart.render)
      end
    end
  end
end
