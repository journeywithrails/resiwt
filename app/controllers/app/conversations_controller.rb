module App
  class ConversationsController < BaseController
    before_filter :get_conversation, :only => [ :show, :edit, :update, :destroy ]
    
    def index
      @conversations = @account.conversations
    end
    
    def new
      @conversation = @account.conversations.build
      authorize! :new, @conversation, :message => "You cannot create more than #{@account.conversations.today.count} conversation(s) per day with your current subscription."
    end
    
    def create
      @conversation = @account.conversations.build(params[:conversation])
      authorize! :create, @conversation, :message => "You cannot create more than #{@account.conversations.today.count} conversation(s) per day with your current subscription."
  
      if @conversation.save
        flash[:notice] = "Conversation has been successfully created."
        redirect_to app_user_account_conversation_path(@account, @conversation)
      else
        render :new
      end
    end
    
    def show
      @statuses = @conversation.statuses
    end
    
    def edit
    end
    
    def update
      if @conversation.update_attributes(params[:conversation])
        flash[:notice] = "Your conversation was successfully updated."
        redirect_to app_user_account_conversation_path(@account, @conversation)
      else
        render :edit
      end
    end
    
    def destroy
      @conversation.destroy
      flash[:notice] = "Conversation has been removed."
      redirect_to app_user_account_conversations_path(@account)
    end
    
    protected
    def get_conversation
      @conversation = @account.conversations.find(params[:id])
    end
  end
end
