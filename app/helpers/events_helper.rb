module EventsHelper
  
  def event_explanation(event)
    case event.object_type.to_s
    when "App::DirectMessage"
      "#{event_author(event)} sent you a #{link_to event_type(event), app_user_account_direct_message_path(@account, event.object.twitter_id)}:" + event_preview(event)
    when "App::Status"
      if event.object.mention?
        "#{event_author(event)} #{link_to "Mentioned you", app_user_account_status_path(@account, event.object.twitter_id)} in a tweet:" + event_preview(event)
      end
    when "App::Charts::Source",
         "App::Charts::HourlyStatusFrequency",
         "App::Charts::DailyStatusFrequency",
         "App::Charts::WeeklyStatusFrequency",
         "App::Charts::MonthlyStatusFrequency",
         "App::Charts::UserStatusFrequency",
         "App::Charts::RetweetsRatio",
         "App::Charts::RetweetsTimelineRatio",
         "App::Charts::HourlyMentionsFrequency",
         "App::Charts::DailyMentionsFrequency",
         "App::Charts::WeeklyMentionsFrequency",
         "App::Charts::MonthlyMentionsFrequency",
         "App::Charts::UserMentionsFrequency",
         "App::Charts::Friends",
         "App::Charts::Followers",
         "App::Charts::Unfollowed",
         "App::Charts::SearchesUnfollowed",
         "App::Charts::SearchesFollowed",
         "App::Charts::Account"
      "The #{link_to event_type(event), timeline_app_user_account_statistics_overview_path(@account)} were updated."
    end
  end
  
  def event_type(event)
    case event.object_type.to_s
    when "App::DirectMessage" then "Direct Message"
    when "App::Status"
      "Mention" if event.object.mention?
    when "App::Charts::Source"
      "Timeline Source Charts"
    when "App::Charts::RetweetsRatio", "App::Charts::RetweetsTimelineRatio"
      "Retweets Ratio Charts"
    when "App::Charts::HourlyStatusFrequency",
         "App::Charts::DailyStatusFrequency",
         "App::Charts::WeeklyStatusFrequency",
         "App::Charts::MonthlyStatusFrequency",
         "App::Charts::UserStatusFrequency"
         "Status Frequency Charts"
    when "App::Charts::HourlyMentionsFrequency",
         "App::Charts::DailyMentionsFrequency",
         "App::Charts::WeeklyMentionsFrequency",
         "App::Charts::MonthlyMentionsFrequency",
         "App::Charts::UserMentionsFrequency"
         "Mentions Frequency Charts"
    when "App::Charts::Friends"
      "Friends Charts"
    when "App::Charts::Followers"
      "Followers Charts"
    when "App::Charts::Unfollowed"
      "Unfollowed Charts"
    when "App::Charts::SearchesUnfollowed"
      "Unfollowed from Search Charts"
    when "App::Charts::SearchesFollowed"
      "Followed from Search Charts"
    when "App::Charts::Account"
      "Account Charts"
    end
  end
  
  # Used in ActionMailer views
  def event_explanation_from_object(account, object)
    klass = object.type ? object.type.to_s : object.class.to_s
    
    case klass
    when "App::DirectMessage"
      "#{object.author.screen_name} sent you a #{link_to "direct message", app_user_account_direct_message_url(account, object.twitter_id)}:" + event_preview(object)
    when "App::Status"
      if object.mention?
        "#{object.author.screen_name} #{link_to "mentioned you", app_user_account_status_url(account, object.twitter_id)} in a tweet:" + event_preview(object)
      end
    when "App::Charts::Source"
      "The #{link_to "timeline sources", timeline_app_user_account_statistics_overview_url(account)} chart was updated."
    when "App::Charts::RetweetsRatio", "App::Charts::RetweetsTimelineRatio"
      "The #{link_to "retweets ratio", retweets_app_user_account_statistics_network_url(account)} charts were updated."
    when "App::Charts::HourlyStatusFrequency",
         "App::Charts::DailyStatusFrequency",
         "App::Charts::WeeklyStatusFrequency",
         "App::Charts::MonthlyStatusFrequency",
         "App::Charts::UserStatusFrequency"
      "The #{link_to "status frequency", timeline_app_user_account_statistics_overview_url(account)} charts were updated."
    when "App::Charts::Friends"
      "The #{link_to "friends chart", friends_app_user_account_statistics_network_url(account)} was updated."
    when "App::Charts::Followers"
      "The #{link_to "followers chart", followers_app_user_account_statistics_network_url(account)} was updated."
    when "App::Charts::Account"
      "The #{link_to "account ratio", app_user_account_statistics_overview_url(account)} chart was updated."
    end
  end
  
  def event_author(event)
    screen_name = event.object.author.screen_name
    link_to(screen_name, app_user_account_person_path(@account, screen_name))
  end
  
  def event_preview(event_or_object)
    object = event_or_object.respond_to?(:object) ? event_or_object.object : event_or_object
    content_tag(:div, format_status(object), :class => "grey preview")
  end
end
