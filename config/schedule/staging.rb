# ----------------------------------------------------
# Staging specific jobs
# ----------------------------------------------------
set :output,   File.join("log", "staging_cron.log")

# ---------------
# Mailers
# every 1.day, :at => "4pm" do
#   rake "jobs:mailer:send_daily_digest RAILS_ENV=staging"
# end

# every :friday, :at => '3pm' do
#   rake "jobs:mailer:send_weekly_digest RAILS_ENV=staging"
# end

# --------------------
# Scheduled Statuses
# every 5.minutes do
#   rake "jobs:scheduled_statuses:publish RAILS_ENV=staging"
# end

# ---------------------
# Subscriptions
# every 1.day, :at => "1am" do
#   rake "application:subscriptions:validate RAILS_ENV=staging"
# end

# ---------------------
# Account
# every 1.hour do
#   rake "jobs:account:refresh RAILS_ENV=staging"
# end

# every 10.minutes do
#   rake "jobs:account:refresh_friends RAILS_ENV=staging"
#   rake "jobs:account:refresh_followers RAILS_ENV=staging"
# end

# every 5.minutes do
#   rake "jobs:account:refresh_rate_limit RAILS_ENV=staging"
# end
