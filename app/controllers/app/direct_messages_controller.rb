module App
  class DirectMessagesController < BaseController
    
    def index
      @direct_messages = @account.direct_messages(:page => params[:page])
      @direct_messages.refresh if @direct_messages.stale?
    end
    
    def show
      @direct_message = @account.direct_messages.find_by_twitter_id(params[:id])
      
      unless @direct_message
        flash[:failure] = "Could not find a direct message with that ID."
        redirect_to app_user_account_direct_messages_path(@account)
      end
    end
    
    def create
      @account.client.direct_message_create(params[:recipient_id], params[:text])
      flash[:notice] = "Your direct message was successfully sent!"
      redirect_back_or app_user_account_direct_messages_path(@account)
    rescue Twitter::General
      flash[:notice] = "Sorry, we could not send that message as #{params[:recipient_id]} is not your friend."
      redirect_back_or app_user_account_direct_messages_path(@account)
    end
    
    def destroy
      @account.client.direct_message_destroy(params[:id])
      flash[:notice] = "Direct message was successfully deleted."
      redirect_back_or app_user_account_direct_messages_path(@account)
    end
    
  end
end
