module Tweasier
  module Jobs
    module Import
      class RefreshBase
        class << self
          def import_job_name(method=nil)
            method ? write_inheritable_attribute(:import_job_name, method) : read_inheritable_attribute(:import_job_name)
          end

          def client_method(method=nil)
            method ? write_inheritable_attribute(:client_method, method) : read_inheritable_attribute(:client_method)
          end

          def twitter_ids_method(method=nil)
            method ? write_inheritable_attribute(:twitter_ids_method, method) : read_inheritable_attribute(:twitter_ids_method)
          end

          def account_method(method=nil)
            method ? write_inheritable_attribute(:account_method, method) : read_inheritable_attribute(:account_method)
          end
          
          def relationship_class(method=nil)
            method ? write_inheritable_attribute(:relationship_class, method) : read_inheritable_attribute(:relationship_class)
          end
          
          def job_name(method=nil)
            method ? write_inheritable_attribute(:job_name, method.to_s) : read_inheritable_attribute(:job_name)
          end
          
          def resque_queue(name)
            @queue = name.to_sym
          end
          
          def perform(data)
            account_id = data['account_id']
            account    = App::Account.find(account_id)
            import_job = ResqueJob.find_by_association_and_record_id(import_job_name, account.id)
            job        = ResqueJob.find_or_create_by_association_and_record_id_and_record_type(job_name, account.id, account.class.to_s)

            cursor = Tweasier::Client::Cursor.new(data["cursor"])
            
            return if import_job && import_job.is_running?
            return if job.is_running? && (job.page == cursor.first_page)
            
            begin
              job.is_running   = true
              job.page         = cursor.to_s
              job.refreshed_at = Time.zone.now if cursor.first_page?
              job.save!
              
              response     = account.client.send(client_method, :cursor => cursor.to_s)
              response_ids = response["ids"]
              new_ids      = response_ids - account.send(twitter_ids_method)
              cursor.next_value = response["next_cursor"]
              
              new_ids.each do |id|
                relationship_account = App::Account.find_by_twitter_id(id)
                begin
                  user                 = account.client.user(id)
                  next if user.screen_name.blank?
                
                  unless relationship_account
                    relationship_account = App::Account.new(:twitter_id => user.id, :screen_name => user.screen_name)
                    relationship_account.from_mash!(user)
                    relationship_account.save!
                  end

                  follower = relationship_class.find_or_initialize_by_to_account_id_and_from_account_id(relationship_account.id, account.id)
                  follower.from_mash!(user)
                  follower.save!
                  
                rescue Twitter::NotFound => ex
                  relationship_account.destroy if relationship_account && relationship_account.user.nil?
                end
              end

              account.send(account_method).touch_synced_timestamp_for(response_ids)
              
              if cursor.has_next?
                Resque.enqueue(self, :account_id => account.id, :cursor => cursor.next_value)
              else
                account.send(account_method).all(:conditions => ["relationships.last_synced_at < ?", job.refreshed_at]).each { |a| a.destroy }
                job.update_attribute(:is_running, false)
              end
            rescue StandardError => e
              job.update_attribute(:is_running, false)
              raise e
            end
          end
        end  
      end
    end
  end
end
