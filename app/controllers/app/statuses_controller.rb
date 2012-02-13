module App
  class StatusesController < BaseController
    
    def show
      @status = @account.statuses.find_by_twitter_id(params[:id])
      render_error 404 unless @status
    end
    
    def create
      options = {}
      
      if @account.geotagging_available?
        options.merge! :lat  => @account.location_hash[:lat]
        options.merge! :long => @account.location_hash[:long]
      end
      
      unless params[:in_reply_to_status_id].blank?
        options.merge!({:in_reply_to_status_id => params[:in_reply_to_status_id]})
      end
      
      respond_to do |wants|
        
        wants.html do
          begin
            @account.client.update(params[:text], options)
            flash[:notice] = "Successfully tweeted."
            redirect_back_or app_user_account_path(@account)
          rescue Twitter::General
            flash[:failure] = "An error occured whilst tweeting."
            redirect_back_or app_user_account_path(@account)
          end
        end
        
        wants.json do
          begin
            @account.client.update(params[:text])
            render :json => { :text => "Status successfully tweeted!" }
          rescue Twitter::General
            render :json => { :text => "Could not tweet status." }
          end
        end
      end
    end
    
    def destroy
      status = Status.find_by_twitter_id(params[:id])
      status.destroy if status
      @account.client.status_destroy(params[:id])
      flash[:notice] = "Tweet successfully deleted."
      redirect_back_or app_user_account_path(@account)
    end
    
  end
end
