module App
  class InvitationsController < BaseController
    skip_before_filter :authenticate,
                  :validate_subscription,
                  :get_account,
                  :assign_default_params,
                  :get_feedback_entry, :only => [:create]
    
    def new
      @invitation = App::Invitation.new
    end
    
    def create
      @invitation = App::Invitation.new(params[:invitation])
      @invitation.sender = current_user
      
      if @invitation.save
        if current_user
          flash[:success] = 'Thank you, your invitation has been sent.'
          Resque.enqueue(Tweasier::Jobs::Mailer::SendInvitation, @invitation.id)
          redirect_to app_home_path
        else
          flash[:success] = 'Thank you, we will notify you when we are ready.'
          redirect_to root_path
        end
      else
        if current_user
          render :new
        else
          render :template => "users/new"
        end
      end
    end
  end
end
