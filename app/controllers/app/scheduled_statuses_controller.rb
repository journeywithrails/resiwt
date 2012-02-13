module App
  class ScheduledStatusesController < BaseController
    before_filter :get_status, :only => [ :edit, :update, :destroy ]
    
    def index
      @statuses = @account.scheduled_statuses.all
    end
    
    def new
      @status = @account.scheduled_statuses.build
    end
    
    def from_status
      @status      = @account.scheduled_statuses.build
      @status.text = params[:text]
      render :layout => false
    end
    
    def create
      @status = @account.scheduled_statuses.build(params[:scheduled_status])
      authorize! :create, @status, :message => "You cannot create more than #{@account.scheduled_statuses.for_date(@status.publish_date).count} scheduled tweets per day with your current subscription."
      
      if @status.save
        flash[:notice] = "Status has been successfully scheduled."
        redirect_to app_user_account_scheduled_statuses_path(@account)
      else
        render :new
      end
    end
    
    def edit
    end
    
    def update
      if @status.update_attributes(params[:scheduled_status])
        flash[:notice] = "Your scheduled status was successfully updated."
        redirect_to app_user_account_scheduled_statuses_path(@account)
      else
        render :edit
      end
    end
    
    def destroy
      @status.destroy
      flash[:notice] = "Status has been unscheduled."
      redirect_to app_user_account_scheduled_statuses_path(@account)
    end
    
    protected
    def get_status
      @status = @account.scheduled_statuses.find(params[:id])
    end
  end
end
