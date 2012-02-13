module App
  class MentionsController < BaseController
    
    def index
      @mentions = @account.mentions(:page => params[:page])
      
      @mentions.refresh if @mentions.stale?
    end
    
  end
end