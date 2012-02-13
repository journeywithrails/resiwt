module App
  class FavouritesController < BaseController
    
    def index
      @statuses = @account.favourites(:page => params[:page])
      @statuses.refresh if @statuses.stale?
    end
    
    def create
      @account.client.favorite_create(params[:id])
      save_status_flag(true)
      flash[:notice] = "Tweet was favourited."
      #@account.refresh_favourites! #FIXME analysis required
      redirect_back_or app_user_account_favourites_path(@account)
    end
    
    def destroy
      @account.client.favorite_destroy(params[:id])
      save_status_flag(false)
      flash[:notice] = "Tweet was removed from favourites."
      #@account.refresh_favourites! #FIXME analysis required
      redirect_back_or app_user_account_favourites_path(@account)
    end
    
    protected
      def save_status_flag(favourited)
        status = @account.statuses.find_by_twitter_id(params[:id])
        return false unless status
        status.favourite = favourited
        status.save
      end
  end
end
