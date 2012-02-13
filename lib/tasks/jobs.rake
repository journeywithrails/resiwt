# -----------------------------------------------
# Tweasier jobs
# -----------------------------------------------

namespace :jobs do
  namespace :mailer do
    desc "Sends out the daily email digest to all accounts who wish to receive them."
    task :send_daily_digest => :environment do
      note "Beginning daily digest"
      breaker
      
      accounts = App::Account.daily_digest
      
      raise "No accounts found with the daily digest preference on!" unless accounts.present?
      
      accounts.each do |account|
        quote "+ #{account.screen_name}"
        account.refresh!
        account.queue_daily_digest_mail!
      end
      
      breaker
      success "#{accounts.size} accounts have had daily digest jobs dispatched."
    end
    
    desc "Sends out the weekly email digest to all accounts who wish to receive them."
    task :send_weekly_digest => :environment do
      note "Beginning weekly digest"
      breaker
      
      accounts = App::Account.weekly_digest
      
      raise "No accounts found with the weekly digest preference on!" unless accounts.present?
      
      accounts.each do |account|
        quote "+ #{account.screen_name}"
        account.refresh!
        account.queue_weekly_digest_mail!
      end
      
      breaker
      success "#{accounts.size} accounts have had weekly digest jobs dispatched."
    end
  end
  namespace :scheduled_statuses do
    desc "Sends all scheduled statuses that are due to be sent"
    task :publish => :environment do
      statuses = App::ScheduledStatus.queued
      
      note "Found #{statuses.size} statuses pending."
      
      statuses.each do |status|
        quote "#{status.account.screen_name} - #{status.publish_date} - '#{status.text}'"
        #Tweasier::Jobs::ScheduledStatus.perform(status.id)
        Resque.enqueue(Tweasier::Jobs::ScheduledStatus, status.id)
      end
    end
  end
end
