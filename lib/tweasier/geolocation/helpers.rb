module Tweasier
  module Geolocation
    module Helpers
      def self.included(base)
        base.send :include, InstanceMethods
      end
      
      module InstanceMethods
        def address_from_geolocation(geolocation)
          return nil if geolocation.blank?
          
          lat  = geolocation[0]
          long = geolocation[1]
          
          result = Tweasier::Geolocation::Base.locate(lat, long)
          
          result
        end
        
        def link_to_geolocation(status)
          
          return "" if status.coordinates.blank?
          
          address = address_from_geolocation(status.coordinates)

          unless address.nil?
            link_to (address.city || "Geo tagged"), app_user_account_map_path(@account, "view", :lat => status.coordinates[0], :long => status.coordinates[1]), :rel => 'facybox'
          else
            ""
          end
        end
      end
    end
  end
end
