namespace :application do
  
  desc "Bootstraps the application and dependencies"
  task :bootstrap => :environment do
    puts ">> Please check:"
    puts "- Redis is already started"
    system "COUNT=5 QUEUE=* rake resque:workers &"
  end
  
  desc "Resets the application database (in development only)"
  task :reset => :environment do
    allowed_environments = %w{ staging development }
    
    raise "Cannot reset environment #{Rails.env} as its not in the allowed list (#{allowed_environments.join(" or ")})!" unless allowed_environments.include?(Rails.env)
    
    Rake::Task["db:migrate:reset"].invoke
    Rake::Task["db:seed"].invoke
    
    RSpreedly::Subscriber.delete_all
    puts "** Deleted all subscribers from the spreedly test site."
  end
  
  desc "Backs the applications database up."
  task :backup => :environment do
    config    = ActiveRecord::Base.configurations[RAILS_ENV || 'development']
    filename  = "#{config['database'].gsub(/_/, '-')}-#{Time.now.strftime('%Y-%m-%d-%H%M%S')}.sql"
    backupdir = File.expand_path(File.join(RAILS_ROOT, '..', '..', "shared", "backups"))
    filepath  = File.join(backupdir, filename)
    mysqldump = `which mysqldump`.strip
    options   =  "-e -u #{config['username']}"
    options   += " -p#{config['password']}" if config['password']
    options   += " -h #{config['host']}"    if config['host']
    
    raise RuntimeError, "I only work with mysql." unless config['adapter'] == 'mysql'
    raise RuntimeError, "Cannot find mysqldump." if mysqldump.blank?
    
    puts "Backing up the database => #{config['database']}"
    
    FileUtils.mkdir_p backupdir
    
    `#{mysqldump} #{options} #{config['database']} > #{filepath}`
    `gzip #{filepath}`
    
    puts "Backed up #{config['database']} => #{filepath}"
  end
end
