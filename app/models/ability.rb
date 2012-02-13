class Ability
  include CanCan::Ability
  
  def initialize(user)
    case(user.feature_level.to_sym)
    when :free
      #RULE 1 don't allow free users to have more than one account
      can :create, App::Account do
        user.has_no_accounts?
      end
      #RULE 5 don't allow free users to have more than 3 scheduled statuses a day
      can :create, App::ScheduledStatus do |status|
        account = user.accounts.first
        status_count = account.scheduled_statuses.count(:conditions => ['publish_date between ? and ?', status.publish_date.midnight, (status.publish_date.midnight + 1.day)])
        (status_count < 3)
      end
      #RULE 6 don't allow more than one conversation per daye for a free user
      can [:create, :new], App::Conversation do |conversation|
        account = user.accounts.first
        conversation_count = account.conversations.count(:conditions => ['created_at between ? and ?', Time.now.midnight, (Time.now.midnight + 1.day)])
        (conversation_count == 0)
      end
      #RULE 8 don't allow more than one search per day for free users
      can [:create, :new], App::Search do |search|
        account = user.accounts.first
        search_count = account.searches.count(:conditions => ['created_at between ? and ?', Time.now.midnight, (Time.now.midnight + 1.day)])
        (search_count == 0)
      end
      #RULE 7 show advertising for free users
      can :view, :advertising
      
      #Report access
      can :app_statistics_overview, :statistics
    #disabled restrictions for beta stage  
    when :paid
      can :create, App::Account
      can :create, App::ScheduledStatus
      can [:create, :new], App::Conversation
      can [:create, :new], App::Search
      
      #Report access
      can [
        :app_statistics_overview,
        :app_statistics_network,
        :app_statistics_usage,
        :app_statistics_timeline,
        :app_statistics_mentions,
        :app_statistics_retweets,
        :app_statistics_friends,
        :app_statistics_followers,
        :app_statistics_links,
        :app_statistics_content
        ], :statistics
        
      cannot :view, :advertisting
    end
  end
end