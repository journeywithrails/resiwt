module Tweasier
  module Jobs
    class ScheduledStatus
      @queue = :scheduled_status
      
      class << self
        def perform(status_id)
          status = App::ScheduledStatus.find(status_id)
          
          return if status.published? or status.publish_date.to_time > Time.now
          
          status.publish!
        end
      end
    end
  end
end
