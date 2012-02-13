# -----------------------------------------------
# Tweasier jobs for scraper
# -----------------------------------------------

namespace :jobs do
  namespace :account do
    namespace :paid do
      desc "Refresh paid accounts"
      task :refresh => :environment do
        note "Beginning refresh at #{Time.now.to_s(:precise)}"
        @accounts = App::Account.paid.all_authenticated
        raise "No accounts found!" unless @accounts.present?

        @accounts.each do |account|
          quote " + #{account.screen_name}"
          account.refresh!
        end

        note "Finished refresh at #{Time.now.to_s(:precise)}"
      end

      desc "Refresh paid account friends"
      task :refresh_friends => :environment do
        note "Beginning refresh at #{Time.now.to_s(:precise)}"
        accounts = App::Account.paid.all_authenticated

        return unless accounts.present?

        accounts.each do |account|
          quote " + #{account.screen_name}"
          account.refresh_friends!
        end

        note "Finished refresh at #{Time.now.to_s(:precise)}"
      end

      desc "Refresh paid account followers"
      task :refresh_followers => :environment do
        note "Beginning refresh at #{Time.now.to_s(:precise)}"
        accounts = App::Account.paid.all_authenticated

        return unless accounts.present?

        accounts.each do |account|
          quote " + #{account.screen_name}"
          account.refresh_followers!
        end

        note "Finished refresh at #{Time.now.to_s(:precise)}"
      end
    end
    
    namespace :free do
      desc "Refresh free accounts"
      task :refresh => :environment do
        note "Beginning refresh at #{Time.now.to_s(:precise)}"
        @accounts = App::Account.free.all_authenticated
        raise "No accounts found!" unless @accounts.present?

        @accounts.each do |account|
          quote " + #{account.screen_name}"
          account.refresh!
        end

        note "Finished refresh at #{Time.now.to_s(:precise)}"
      end

      desc "Refresh free account friends"
      task :refresh_friends => :environment do
        note "Beginning refresh at #{Time.now.to_s(:precise)}"
        accounts = App::Account.free.all_authenticated

        return unless accounts.present?

        accounts.each do |account|
          quote " + #{account.screen_name}"
          account.refresh_friends!
        end

        note "Finished refresh at #{Time.now.to_s(:precise)}"
      end

      desc "Refresh free account followers"
      task :refresh_followers => :environment do
        note "Beginning refresh at #{Time.now.to_s(:precise)}"
        accounts = App::Account.free.all_authenticated

        return unless accounts.present?

        accounts.each do |account|
          quote " + #{account.screen_name}"
          account.refresh_followers!
        end

        note "Finished refresh at #{Time.now.to_s(:precise)}"
      end
    end
    
    desc "Refresh all account rate limits"
    task :refresh_rate_limit => :environment do
      accounts = App::Account.all_authenticated
      
      accounts.each do |account|
        account.refresh_rate_limit!
      end
    end
  end
end
