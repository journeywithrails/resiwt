module App
  class SuggestionsController < BaseController
    SUGGESTION_LIMIT = 10
    
    protected
    def get_suggestions_for(screen_name, client_method)
      filtered_suggestions = []
      suggestions          = @account.client.send(client_method, :screen_name => screen_name)
      
      suggestions.each do |suggestion|
        a = Account.new(:screen_name => suggestion.screen_name,
                        :description => suggestion.description,
                        :profile_image_url => suggestion.profile_image_url,
                        :twitter_id => suggestion.id)
        
        a.influence = generate_influence_for(a, suggestion)
        filtered_suggestions << a
      end
      
      filtered_suggestions.delete_if { |a| @account.is_following?(a) || @account.is_twitter_user?(a) }
      filtered_suggestions = filtered_suggestions.sort_by { rand }.slice(0..(SUGGESTION_LIMIT - 1))
    end
  end
end
