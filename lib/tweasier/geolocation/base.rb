require 'google/geo'

module Tweasier
  module Geolocation
    class Base
      class << self

        def locate(*args)
          begin
            results = client.locate(*args)
            # Returns an Address object or nil
            results and results.is_a?(Array) ? results.first : nil
          rescue Google::Geo::BadRequestError => error
            #HoptoadNotifier.notify error
            nil
          rescue Google::Geo::UnknownAddressError => error
            #HoptoadNotifier.notify error
            nil
          rescue Google::Geo::TooManyQueriesError => error
            #HoptoadNotifier.notify error
            nil
          rescue => error
            #HoptoadNotifier.notify error
            nil
          end
        end
        
        def client
          @client ||= Google::Geo.new(Configuration.google_maps.api_key)
        end
      end
    end
  end
end
