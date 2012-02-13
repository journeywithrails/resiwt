# ----------------------------------------------------
# Production specific jobs
# ----------------------------------------------------
set :output,   File.join("log", "production_cron.log")

# ---------------
# Mailers
every 1.day, :at => "4pm" do
  rake "jobs:mailer:send_daily_digest RAILS_ENV=production"
end

every :friday, :at => '3pm' do
  rake "jobs:mailer:send_weekly_digest RAILS_ENV=production"
end

# --------------------
# Scheduled Statuses
every 5.minutes do
  rake "jobs:scheduled_statuses:publish RAILS_ENV=production"
end

# ---------------------
# Subscriptions
every 1.day, :at => "1am" do
  rake "application:subscriptions:validate RAILS_ENV=production"
end

# ---------------------
# Account
every 30.minutes do
  rake "jobs:account:paid:refresh RAILS_ENV=production"
end

every 30.minutes do
  rake "jobs:account:paid:refresh_friends RAILS_ENV=production"
  rake "jobs:account:paid:refresh_followers RAILS_ENV=production"
end

every 1.day, :at => "2am" do
  rake "jobs:account:free:refresh RAILS_ENV=production"
end

every 1.day, :at => "2am" do
  rake "jobs:account:free:refresh_friends RAILS_ENV=production"
  rake "jobs:account:free:refresh_followers RAILS_ENV=production"
end

every 30.minutes do
  rake "jobs:account:refresh_rate_limit RAILS_ENV=production"
end
