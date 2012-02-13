module Tweasier
  module Jobs
    module Scraper
      class Base
        class << self
          def client_method(method=nil)
            method ? write_inheritable_attribute(:client_method, method) : read_inheritable_attribute(:client_method)
          end
          
          def resque_queue(name)
            @queue = "scraper"
          end
          
          def perform(data)
            data.symbolize_keys!
            scraper = self.new
            scraper.page = data[:page]
            scraper.job = ResqueJob.find data[:job_id]
            
            if scraper.job.record.nil?
              scraper.job.destroy
              return
            end
            
            scraper.input = []
            scraper.output = []
            begin
              scraper.scrape!
              scraper.job.update_attributes(:is_running => false, :refreshed_at => Time.zone.now)
            rescue => e
              #Update the job attributes even if the job throws an exception
              scraper.job.update_attributes(:is_running => false, :refreshed_at => Time.zone.now)
              raise e
            end
            scraper.output
          end
        end
        
        attr_accessor :input, :output, :job, :page
        
        def client_args
          @client_args ||={}
        end
        
        def record
          job.record
        end
        
        def association
          job.association
        end
        
        def page
          job.page
        end
        
        def scrape!
          fire_callback(:before_scrape)
          
          method = self.class.client_method
          args   = self.client_args
          
          if self.record.rate_limit_hit?
            #HoptoadNotifier.notify(:error_class => Twitter::RateLimitExceeded, :error_message => "Rate limit hit for #{self.record.screen_name} (#{self.record.id})")
            raise Twitter::RateLimitExceeded, "Rate limit hit for #{record.screen_name} (#{record.id})"
          end
          
          begin
            self.input = self.record.client.send(method, args)
          rescue Twitter::Unavailable, SocketError => e
            # Swallow known dead ends that don't cause concern.
          rescue => e
            #HoptoadNotifier.notify(:error_class => e.class.name, :error_message => e.message)
            raise e
          end
          
          fire_callback(:after_scrape)
        end
        
        def client
          Tweasier::Client::Base.new(self, Configuration.twitter.auth_token, Configuration.twitter.auth_secret)
        end
        
        protected
        def fire_callback(type)
          method = type.to_sym
          return unless self.respond_to?(method)
          self.send(method)
        end
      end
    end
  end
end
