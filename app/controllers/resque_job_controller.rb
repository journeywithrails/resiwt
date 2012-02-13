class ResqueJobController < ApplicationController
  before_filter :get_user,
                :get_account
  
  def show
    @job = ResqueJob.find params[:id]
    
    if @job.nil?
      render_error(404)
    elsif @job.is_running
      #Job is running, show a default template that tells the AJAX call to ring back later
      #Send a 412 which is "precondition failed". Probably the most appropriate status code
      render :json => @job, :status => 412
    else    
      render :partial => "resque_job/#{@job.record_type.underscore}/#{@job.association}", :locals => { :association => @job.record.send(@job.association) }
    end
  end
  
  protected
    def get_user
      @user ||= presenter_for(current_user)
    end
  
    def get_account
      return unless @user and params[:account_id]
      @account ||= presenter_for(@user.accounts.find_by_screen_name(params[:account_id]))
    end
    
end
