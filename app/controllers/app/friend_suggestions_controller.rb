module App
  class FriendSuggestionsController < SuggestionsController
    
    def index
      @suggestions = get_suggestions_for(params[:friend_id], :friends)
    end
  end
end
