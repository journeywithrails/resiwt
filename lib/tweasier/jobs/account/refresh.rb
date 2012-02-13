module Tweasier
  module Jobs
    module Account
      class Refresh
        class << self
          def resque_queue(name)
            @queue = "refresh_#{name}".to_sym
          end
        
          def association(method=nil)
            method ? write_inheritable_attribute(:association, method) : read_inheritable_attribute(:association)
          end
        
          def account_ready_state(method=nil)
            method ? write_inheritable_attribute(:account_ready_state, method) : read_inheritable_attribute(:account_ready_state)
          end
        
          def perform(account_id)
            account = App::Account.find(account_id)
            return true unless account
          
            obj = account.send(self.association)
            obj.refresh! if obj.stale?
            account.add_ready_state(account_ready_state)
          end
        end
      end
    end
  end
end
