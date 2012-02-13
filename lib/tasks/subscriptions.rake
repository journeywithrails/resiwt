namespace :application do
  namespace :subscriptions do
    desc "Validates all subscriptions to their current plan"
    task :validate => :environment do
      puts ">> Validating all user subscriptions:"
      
      users = User.all
      
      users.each do |user|
        previous_level = user.feature_level
        user.refresh_subscription!
        
        puts "Refreshed user feature level definition: #{previous_level || "dead"} => #{user.feature_level || "dead"}"
      end
      
      puts ">> Subscriptions validated."
    end
  end  
end
