# -------------------------------------
# Main Cap file
# -------------------------------------
set :default_env, 'staging'
set :rails_env,   ENV['rails_env'] || ENV['RAILS_ENV'] || ENV['e'] || default_env

ssh_options[:port]        = 62000
ssh_options[:paranoid]    = false
default_run_options[:pty] = true
set :use_sudo, false
set :blog_path, "/home/twdeploy/sites/blog.tweasier.com/current"

set :scm,        "git"
set :repository, "git@server1.hawkinsking.com:tweasier.git"

set :user,        "twdeploy"
set :runner,      "twdeploy"
set :giternal_binary, "giternal"
set :whenever_binary, "whenever"

set  :main_server, "server2.tweasier.com"
#set  :secondary_server, "174.143.154.165"
role :app, main_server
role :web, main_server
role :db,  main_server, :primary => true

recipe_file = File.expand_path(File.join(File.dirname(__FILE__), 'deploy', "#{rails_env}.rb"))
if File.exists?(recipe_file)
  puts "Loaded #{rails_env} recipe" if load(recipe_file)
else
  puts "Could not find #{rails_env} recipe file!"
end



namespace :deploy do
  
  desc "Does a backup, updates code, updates externals, symlinks, migrates, notifys hoptoad and restarts."
  task :full do
    update_code
    symlink
    migrate
    restart
  end
  
  #before "deploy:update_code", "deploy:backup"
  after "deploy:update_code", "deploy:remove_clutter"
  after "deploy:update_code", "deploy:update_externals"
  after "deploy:symlink", "deploy:symlink_blog"
  after "deploy:symlink", "deploy:update_crontab"
  after "deploy", "deploy:cleanup"
  
  desc "Symlinks the blog to the subfolder /blog within the Rails app."
  task :symlink_blog do
    puts "-- creating blog symlink..."
    run "rm -rf #{current_path}/public/blog"
    run "ln -s #{blog_path} #{current_path}/public/blog"
    puts "-- symlinked."
  end
  
  desc "removes random files that are created during updating code"
  task :remove_clutter do
    rails_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))
    files      = [File.join(rails_root, "mkmf.log")]
    
    files.each do |file|
      puts "  ** Removing #{file}"
      system "rm #{file}" if File.exists?(file)
    end
  end
  
  desc "Restarts this application when running passenger"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt" 
    Thread.new { `curl -s http://#{host} $2 > /dev/null` }.kill
  end
  
  desc "Updates GIT externals through giternal"
  task :update_externals do
    run "cd #{release_path} && #{giternal_binary} update"
  end
  
  desc "Backs up the application assets and database content to RAILS_ROOT/../shared/backups"
  task :backup do
    run "cd #{deploy_to}current && rake application:backup RAILS_ENV=#{rails_env}"
  end
  
  desc "Update the crontab file from the rules within the CRON schedule"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && #{whenever_binary} --update-crontab #{application} --set environment=#{rails_env} --load-file #{release_path}/config/schedule/#{rails_env}.rb"
  end
  
  namespace :web do
    task :disable, :roles => :web do
      on_rollback { rm "#{shared_path}/system/maintenance.html" }
      
      require 'erb'
      deadline, reason = ENV['UNTIL'], ENV['REASON']

      maintenance = ERB.new(File.read("./app/views/layouts/maintenance.html.erb")).result(binding)

      put maintenance, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
    
  end
  
end
