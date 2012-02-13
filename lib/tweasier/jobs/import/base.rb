module Tweasier
  module Jobs
    module Import
      class Base
        class << self
          def client_method(method=nil)
            method ? write_inheritable_attribute(:client_method, method) : read_inheritable_attribute(:client_method)
          end
          
          def relationship_class(method=nil)
            method ? write_inheritable_attribute(:relationship_class, method) : read_inheritable_attribute(:relationship_class)
          end
          
          def account_ready_state(method=nil)
            method ? write_inheritable_attribute(:account_ready_state, method) : read_inheritable_attribute(:account_ready_state)
          end
          
          def resque_queue(name)
            @queue = name.to_sym
          end
          
          def perform(data)
            account_id = data['account_id']
            
            account  = App::Account.find(account_id)
            cursor   = Tweasier::Client::Cursor.new(data["cursor"])
            response = account.client.send(client_method, :cursor => cursor.to_s)
            cursor.next_value = response.next_cursor
            
            response.users.each do | mash |
              next if mash.screen_name.blank?
              
              relationship_account = App::Account.find_or_create_by_twitter_id_and_screen_name(mash.id, mash.screen_name)
              relationship = relationship_class.find_or_initialize_by_to_account_id_and_from_account_id(relationship_account.id, account.id)
              relationship.from_mash!(mash)
              relationship.save!
            end
            
            if cursor.has_next?
              Resque.enqueue(self, :job_id => data['job_id'], :account_id => account.id, :cursor => cursor.next_value)
            else
              account.add_ready_state(account_ready_state)
              job = ResqueJob.find(data['job_id'])
              job.update_attributes(:is_running => false)
            end
          end
        end
      end
    end
  end
end
