module App
  class FriendshipsController < BaseController
    
    def create
      respond_to do |wants|
        wants.js do
          begin
            user = @account.client.friendship_create(params[:user])
            log_created_friendship(user)
            render :json => { :text => "You are now following #{params[:user]}" }
          rescue Twitter::General
            render :json => { :text => "You are already following #{params[:user]}" }
          end
        end
        wants.html do
          begin
            user = @account.client.friendship_create(params[:user])
            log_created_friendship(user)
            flash[:notice] = "You are now following #{params[:user]}."
            redirect_back_or app_user_account_person_path(@account, :id => params[:user])
          rescue Twitter::General
            flash[:failure] = "An error occured, this if probably because you are already following #{params[:user]}."
            redirect_back_or app_user_account_person_path(@account, :id => params[:user])
          end
        end
      end
    end
    
    def destroy
      respond_to do |wants|
        wants.js do
          begin
            user = @account.client.friendship_destroy(params[:id])
            log_destroyed_friendship(user)
            render :json => { :text => "You are no longer following #{params[:id]}, however they may take a few minutes to clear from our cache." }
          rescue Twitter::General
            render :json => { :text => "You were not following #{params[:id]} when we attempted to unfollow." }
          end
        end
        wants.html do
          begin
            user = @account.client.friendship_destroy(params[:id])
            log_destroyed_friendship(user)
            flash[:notice] = "You are no longer following #{params[:id]}, however they may take a few minutes to clear from our cache."
            redirect_back_or app_user_account_person_path(@account, :id => params[:id])
          rescue Twitter::General
            flash[:failure] = "An error occured, probably because you are not following #{params[:id]}."
            redirect_back_or app_user_account_person_path(@account, :id => params[:id])
          end
        end
      end
    end
    
    protected
    def log_created_friendship(user)
      account = App::Account.find_by_screen_name(user.screen_name)
      
      if account
        unfollowed_relationship = @account.unfollowed.first(:conditions => ['to_account_id = ?', account.id])
        unfollowed_relationship.destroy if unfollowed_relationship
      end
      
      opts = {}
      opts.merge!(:search_id => params[:search_id]) if params[:search_id]
      @account.friends.build.from_mash!(user, opts).save!
    end
    
    def log_destroyed_friendship(user)
      account = App::Account.find_by_screen_name(user.screen_name)
      
      if account
        friendship = @account.friends.first(:conditions => ['to_account_id = ?', account.id])
        friendship.destroy if friendship
      end
      
      @account.unfollowed.build.from_mash!(user).save!
    end
  end
end
