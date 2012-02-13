module ResqueJobHelper
  
  def refresh_poller(data, id)
    job = if data.is_a?(ResqueJob)
              data
          elsif data.respond_to?(:job)
              data.stale? ? data.job : nil
          else 
            nil 
          end
    
    return if job.nil?
    
    render :partial => 'resque_job/poller', :locals => {:job => job, :id => id}
  end
  
end
