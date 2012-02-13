module Tweasier
  module Client
    class Base
      attr_accessor :account, :twitter_auth_token, :twitter_auth_secret
      
      def initialize(account, twitter_auth_token, twitter_auth_secret)
        self.account             = account
        self.twitter_auth_token  = twitter_auth_token
        self.twitter_auth_secret = twitter_auth_secret
      end
      
      def method_missing(method_name, *args)
        remote_client.send(method_name, args)
      end
      
      def remote_client
        @remote_client ||= begin
          Remote.new(self.account, self.twitter_auth_token, self.twitter_auth_secret)
        end
      end
    end
  end
end
