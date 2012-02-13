namespace :application do
  namespace :statistics do
    desc "Overview of account statistics on the site"
    task :accounts => :environment do
      users = User.all
      
      success "#{users.size} users found."
      
      users.each do |user|
        puts ""
        success "#{user.email} (#{user.accounts.count} accounts)"
        user.accounts.each do |account|
          puts ""
          note account.screen_name
          quote "  - #{account.events.count} events"
          quote "  - #{account.friends.count} friends"
          quote "  - #{account.followers.count} followers"
          quote "  - #{account.searches.count} searches"
          quote "  - #{account.scheduled_statuses.pending.count} scheduled tweets waiting to be processed (#{account.scheduled_statuses.count} in total)."
        end
      end
    end
    
    desc "Overview of all statistics on the site"
    task :all => :environment do
      success "Application stats:"
      quote "  - #{User.count} users in total"
      quote "  - #{User.count :conditions => { :feature_level => "paid" }} paid accounts"
      quote "  - #{User.count :conditions => { :feature_level => "free" }} free accounts"
      quote "  - #{App::Account.count} accounts in total"
      quote "  - #{Event.count} events across all accounts"
      quote "  - #{ResqueJob.count} Resque jobs dispatched across all accounts"
      quote "  - #{Feedback::FeedbackEntry.count} bits of feedback given"
      quote "  - #{Feedback::PollEntry.count} poll entries made"
      quote "  - #{App::Relationships::Follower.count} follower connections across the site"
      quote "  - #{App::Relationships::Friend.count} friend connections across the site"
      quote "  - #{App::Relationships::Unfollowed.count} unfollowed/removed connections across the site"
      quote "  - #{App::Status.count} statuses in total"
      quote "  - #{App::ScheduledStatus.count} scheduled statuses in total (#{App::ScheduledStatus.pending.count} waiting to be processed)"
      quote "  - #{App::Conversation.count} conversations in total"
      quote "  - #{App::Search.count} searches in total (with #{App::SearchCondition.count} conditions across all)"
      quote "  - #{App::Invitation.count(:include => 'recipient', :conditions => 'users.invitation_id is not null')} converted invitations"
      quote "  - #{App::Invitation.count(:include => 'recipient', :conditions => 'users.invitation_id is null')} unconverted invitations"
    end
  end
end
