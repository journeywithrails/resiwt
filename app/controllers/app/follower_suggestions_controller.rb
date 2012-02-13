module App
  class FollowerSuggestionsController < SuggestionsController
    
    def index
      @suggestions = get_suggestions_for(params[:follower_id], :followers)
    end
  end
end
