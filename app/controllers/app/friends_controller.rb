module App
  class FriendsController < BaseController
    
    def index
      @friends = @account.friends(:page => params[:page])
      @friends.refresh if @friends.stale?
    end
    
    def sort
      @friends = @account.friends.sorted(params[:type], :page => params[:page], :account => @account)
      render :index
    end
    
    def search
      @friends = @account.friends.search(params[:q], :page => params[:page])
    end
  end
end
