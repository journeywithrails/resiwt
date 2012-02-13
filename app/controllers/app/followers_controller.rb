module App
  class FollowersController < BaseController
    
    def index
      @followers = @account.followers(:page => params[:page])
      @followers.refresh if @followers.stale?
    end
    
    def sort
      @followers = @account.followers.sorted(params[:type], :page => params[:page], :account => @account)
      render :index
    end
    
    def search
      @followers = @account.followers.search(params[:q], :page => params[:page])
    end
  end
end
