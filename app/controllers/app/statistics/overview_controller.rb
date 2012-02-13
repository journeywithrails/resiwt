module App
  module Statistics
    class OverviewController < StatisticsController
      
      def show
        @person = @account.client.user(@account.screen_name)
      end
      
      def timeline
        @total_statuses = @account.statuses.count
        @account.ensure_fresh_chart_for(:user_status_frequency)
        @account.ensure_fresh_chart_for(:daily_status_frequency)
        @account.ensure_fresh_chart_for(:weekly_status_frequency)
        @account.ensure_fresh_chart_for(:monthly_status_frequency)
        @account.ensure_fresh_chart_for(:hourly_status_frequency)
        @grouped_statuses = @account.home_timeline(:limit => 1000).group_by { |s| s.author.screen_name }
      end
      
      def mentions
        @account.ensure_fresh_chart_for(:user_mentions_frequency)
        @account.ensure_fresh_chart_for(:daily_mentions_frequency)
        @account.ensure_fresh_chart_for(:weekly_mentions_frequency)
        @account.ensure_fresh_chart_for(:monthly_mentions_frequency)
        @account.ensure_fresh_chart_for(:hourly_mentions_frequency)
        @grouped_users = @account.mentions(:limit => 1000).group_by { |s| s.author.screen_name }
      end
    end
  end
end
