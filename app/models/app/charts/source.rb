module App
  module Charts
    class Source < Base
      
      def regenerate!
        values  = {}
        grouped = self.account.home_timeline.group_by { |s| s.source }
        
        grouped.each do |source, collection|
          values[escaped_source(source)] = collection.size
          #values << { :value => collection.size, :label => escaped_source(source) }
        end
        values = Hash[*values.sort {|a,b| a[1]<=>b[1]}.reverse.flatten]
        cache_data(values.to_yaml)
      end
      
      def highchart_data
        YAML.load(data)
      end
      
      def to_csv
        values  = []
        grouped = self.account.home_timeline.group_by { |s| s.source }

        csv_data = generate_csv(["Source", "Count"]) do |row|
          grouped.each do |source, collection|
            row << [escaped_source(source), collection.size]
          end
        end
        
        return {:data => csv_data, :headers => csv_headers}
      end
    end
    
    private
    def escaped_source(source)
      source.nil? ? "Unknown" : source.gsub(/<a[^>]+>(.*)<\/a>/, '\\1')
    end
  end
end
