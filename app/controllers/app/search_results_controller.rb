module App
  class SearchResultsController < BaseController
    before_filter :get_search, :only => [:create]
    
    def create
      respond_to do |wants|
        wants.js do
          @results          = []
          @results_accounts = []
          
          unless @search.parameterize.blank?
            search_results = Tweasier::Search::Base.new(@search.parameterize).run!
            
            search_results.each do |result|
              status = App::Status.find_or_initialize_by_twitter_id_and_account_id(result.id, @account.id)
              status = status.from_search_mash(result, @search, @account) if status.new_record?
              status.save!
              @results          << status
              @results_accounts << status.author
            end
            
            @results_accounts = @results_accounts.uniq.delete_if { |a| a.screen_name == @account.screen_name }
          end
        end
      end
    end
    
    protected
    def get_search
      @search = @account.searches.find params[:search_id]
    end
  end
end
