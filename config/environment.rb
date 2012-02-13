RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'haml'
  config.gem 'pat-maddox-giternal',     :lib => 'giternal'
  config.gem 'thoughtbot-clearance',    :lib => 'clearance'
  config.gem 'resque',                  :lib => 'resque', :source => 'http://gemcutter.org'
  config.gem 'whenever',                :lib => false,    :source => 'http://gemcutter.org'
  config.gem 'friendly_id'
  config.gem 'rest-client',             :lib => "restclient"
  config.gem 'rspreedly'
  config.gem 'twitter',                 :version => ">=0.9.8"
  config.gem 'hashie',                  :version => ">=0.2.1"
  config.gem 'configr'
  config.gem 'bitly'
  config.gem 'cancan'
  config.gem 'chronic'
  
  config.load_paths << Rails.root.join("app", "observers").to_s
  config.load_paths << Rails.root.join("app", "presenters").to_s
  
  #TODO get this bad boy working
  # if ENV['RESQUE']
  #   config.frameworks -= [:action_controller,:action_view, :action_mailer]
  # end
  
  config.frameworks -= [:active_resource]
  config.active_record.observers = %w{ user_observer }
  config.time_zone = 'London'
  
  require 'rspreedly'
  
  config.after_initialize do
    ClearanceMailer.class_eval { layout "mailer" }
    ExceptionNotification::Notifier.exception_recipients = %w(dannyhawkins@me.com)
  end
end
