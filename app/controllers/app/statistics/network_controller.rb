module App
  module Statistics
    class NetworkController < StatisticsController
      
      def show
        @account.ensure_fresh_chart_for(:account)
        @influential_friends   = @account.friends_accounts.all :order => "accounts.influence DESC", :limit => 10
        @influential_followers = @account.follower_accounts.all :order => "accounts.influence DESC", :limit => 10
        @popular_friends_by_followers = @account.friends.all :order => "followers_count DESC", :limit => 10
        @popular_friends_by_friends   = @account.friends.all :order => "friends_count DESC", :limit => 10
        @popular_followers_by_followers = @account.followers.all :order => "followers_count DESC", :limit => 10
        @popular_followers_by_friends   = @account.followers.all :order => "friends_count DESC", :limit => 10
      
        respond_to do |wants|
          wants.js
          wants.html
        end
      end
      
      def friends
        respond_to do |wants|
          wants.html do
            @friends_count     = @account.friends.count
            @friends           = @account.friends.recent
            @account.ensure_fresh_chart_for(:friends)
            
            @users_count = @account.unfollowed.count
            @users       = @account.unfollowed.recent
            @account.ensure_fresh_chart_for(:unfollowed)
          end
          wants.csv do
            csv = @account.friends_chart.to_csv
            send_data(csv[:data], csv[:headers])
          end
        end
      end
      
      def followers
        respond_to do |wants|
          wants.html do
            @followers_count = @account.followers.count
            @followers       = @account.followers.recent
            @account.ensure_fresh_chart_for(:followers)
          end
          wants.csv do
            csv = @account.followers_chart.to_csv
            send_data(csv[:data], csv[:headers])
          end
        end
      end
      
      def retweets
        respond_to do |wants|
          wants.html do
            @account.ensure_fresh_chart_for(:retweets_timeline_ratio)
            @account.ensure_fresh_chart_for(:retweets_ratio)

            retweets = @account.retweets
            @grouped_retweets = retweets.group_by { |r| r.author.screen_name }.sort { |a, b| b[1].size <=> a[1].size }
          end
          wants.csv do
            csv = @account.retweets_ratio_chart.to_csv
            send_data(csv[:data], csv[:headers])
          end
        end
      end
      
      def usage        
        respond_to do |wants|
          wants.js
          wants.html do
            @grouped_users = @account.home_timeline(:limit => 1000).group_by { |s| s.author.screen_name }
            @account.ensure_fresh_chart_for(:source)
          end
          wants.csv do
            csv = @account.source_chart.to_csv
            send_data(csv[:data], csv[:headers])
          end
        end
      end
    end
  end
end
