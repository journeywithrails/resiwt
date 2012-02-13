module App
  class UsersController < BaseController
    ssl_required :create, :new, :edit, :update, :destroy
    
    def show
    end
    
    def edit
    end
    
    def update
      params[:user] = params[:user_presenter] if params[:user_presenter]
      
      if @user.update_attributes(params[:user])
        flash[:success] = "Your account was successfully updated."
        redirect_to app_user_path
      else
        flash[:error] = "There was a problem updating your account, please try again."
        render :action => "edit"
      end
    end
    
    def destroy
      @user.destroy
      
      flash[:success] = "Your account has been deleted. Sorry to see you leave!"
      redirect_to home_path
    end
    
  end
end
