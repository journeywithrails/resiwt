module App
  class PeopleController < BaseController
    
    def show
      begin
        @person           = @account.client.user(params[:id])
        @tweasier_account = Account.find_by_screen_name(params[:id])
      rescue Twitter::NotFound
        render_error 404
      end
    end
  end
end
