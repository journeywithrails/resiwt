namespace :scheduled_statuses do

  desc "Lists all scheduled statuses that are due to be sent"
  task :report => :environment do
    statuses = App::ScheduledStatus.queued
    
    raise "No statuses!" unless statuses.present?
    
    note "Found #{statuses.size} statuses pending."
    
    statuses.each do |status|
      quote "#{status.account.screen_name} - #{status.publish_date} - '#{status.text}'"
    end
  end
end
