module App
  module Charts
    class Account < Base
      
      def regenerate!
        person = self.account.client.user(@account.screen_name)
        
        values = {}
        values['following'] = person.friends_count
        values['followers'] = person.followers_count
        cache_data(values.to_yaml)
      end
      
      def highchart_data
        YAML.load(data)
      end
    end
  end
end
