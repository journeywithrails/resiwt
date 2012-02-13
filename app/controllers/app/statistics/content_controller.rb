module App
  module Statistics
    class ContentController < StatisticsController
      
      def show
        all_link_statuses        = @account.statuses.containing_links
        @total_links_by_account  = @account.own_statuses.containing_links.count
        @total_links_by_everyone = all_link_statuses.count
        @top_link_sharers        = all_link_statuses.group_by { |s| s.author }.sort { |a, b| b[1].size <=> a[1].size }.slice(0..9)
        @total_tweets_with_mention  = @account.statuses.containing_mention.count
        @total_tweets_with_question = @account.statuses.containing_question.count
      end
      
      def searches
        @followed      = @account.friends.count
        @unfollowed    = @account.unfollowed.count
        total_people   = @followed + @unfollowed
        
        @followed_percentage   = @followed.as_percentage_of(total_people)
        @unfollowed_percentage = @unfollowed.as_percentage_of(total_people)
        
        @unaccountable_followed   = @account.friends.all(:conditions => ['search_id IS NULL'])
        @unaccountable_unfollowed = @account.unfollowed.all(:conditions => ['search_id IS NULL'])
        @unaccountable = @unaccountable_followed + @unaccountable_unfollowed
        
        @searches            = @account.searches.all :include => [:friends, :unfollowed]
        @total_search_people = @searches.collect { |s| s.friends.count }.inject(nil) { |sum, x| sum ? sum + x : x } + @unaccountable.size
        @total_found         = @followed + @unfollowed + @unaccountable.size
        
        @account.ensure_fresh_chart_for(:account)
        @account.ensure_fresh_chart_for(:searches_followed)
        @account.ensure_fresh_chart_for(:searches_unfollowed)
      end
    end
  end
end
