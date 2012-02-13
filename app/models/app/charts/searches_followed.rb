module App
  module Charts
    class SearchesFollowed < Base
      
      def regenerate!
        values = []
        
        self.account.searches.each do |search|
          values << {:value => search.friends.count, :label => "#{search.title} (#{search.friends.count} people)" }
        end
        
        conds         = {:conditions => ['search_id IS NULL']}
        unaccountable = self.account.friends.count(conds)
        
        values << { :value => unaccountable, :label => "Unaccountable (#{unaccountable} people)" }
        chart = build_bar_chart(values, "#val# people", "followed users")
        
        cache_data(chart.render)
      end
    end
  end
end
