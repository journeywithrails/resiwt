module App
  class AccountsController < BaseController
    ssl_required :create, :finalize, :edit, :update, :destroy, :new

    before_filter :get_account, :only => [ :show, :edit, :update, :destroy ]

    def new
      authorize! :create, App::Account, :message => "Your current subscription level does not allow you to add more accounts"
    end

    def create
      authorize! :create, App::Account, :message => "Your current subscription level does not allow you to add more accounts"
      
      oauth.set_callback_url(finalize_app_user_accounts_url)

      session['request_token']  = oauth.request_token.token
      session['request_secret'] = oauth.request_token.secret

      redirect_to "http://#{oauth.request_token.authorize_url}"
    end
    
    def finalize
      oauth.authorize_from_request(session['request_token'],
                                   session['request_secret'],
                                   params[:oauth_verifier])
      
      session['request_token']  = nil
      session['request_secret'] = nil
      
      profile = Twitter::Base.new(oauth).verify_credentials
      account = Account.find_or_create_by_screen_name_and_twitter_id(profile.screen_name, profile.id)
      account.from_mash!(profile)
      
      if account.user_id.nil?
        account.update_attribute(:user_id, @user.id)
      elsif (account.user_id != @user.id) or !account.valid?
        flash[:failure] = "Sorry, it seems like someone else has registered that account with Tweasier."
        redirect_to app_user_path
        return
      end
      
      account.update_attributes({
        :atoken  => oauth.access_token.token,
        :asecret => oauth.access_token.secret,
        :rate_limt => 1000
      })
      
      account.refresh!
      
      friends_job = ResqueJob.find_or_create_by_association_and_record_id(:association => "import_friends", :record_type => account.class.to_s, :record_id => account.id, :is_running => true)
      follower_job = ResqueJob.find_or_create_by_association_and_record_id(:assocation => "import_followers", :record_type => account.class.to_s, :record_id => account.id, :is_running => true)
      
      Resque.enqueue(Tweasier::Jobs::Import::Friends, :job_id => friends_job.id, :account_id => account.id)
      Resque.enqueue(Tweasier::Jobs::Import::Followers, :job_id => follower_job.id, :account_id => account.id)
      
      flash[:success] = "Your account was successfully added to Tweasier! We are busy fetching your information so in the mean time please check your preferences."
      redirect_to edit_app_user_account_path(account.screen_name)
    end
    
    def show
      @statuses = @account.home_timeline(:page => params[:page])
      #changed to get to run instantly
      @statuses.refresh if @statuses.stale?
    end
    
    def edit
    end
    
    def update
      
      if @account.update_attributes(params[:account])
        # Additional bit.ly test
        if !@account.link_shortening_available?
          flash[:success] = "Account was successfuly updated."
          redirect_to edit_app_user_account_path(@account)
        else
          if @account.links.build.test!
            flash[:success] = "Account was successfuly updated."
            redirect_to edit_app_user_account_path(@account)
          else
            flash[:success] = "Your details were saved however your Bit.ly credentials seem incorrect. Please check them and try again."
            @account.reset_bitly_credentials!
            render :action => "edit"
          end
        end
        
      else
        flash[:failure] = "An error occured whilst saving your account. Please check the information you entered and try again."
        render :action => "edit"
      end
    end
    
    def destroy
      @account.destroy_as_user_account!
      flash[:success] = "Your account '#{@account.screen_name}' was successfully removed from Tweasier."
      redirect_to app_user_path
    end
    
    private
    def get_account
      @account = @user.accounts.find_by_screen_name(params[:id])
      
      unless @account
        flash[:failure] = "Sorry, we could not find an account by the name of '#{params[:id]}'"
        redirect_to app_user_path
      end
    end
    
    def oauth
      @oauth ||= Twitter::OAuth.new(Configuration.twitter.auth_token, Configuration.twitter.auth_secret, :sign_in => true)
    end
    
  end
end
