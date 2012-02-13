rails_env = ENV['RAILS_ENV']  || "development"

configs = {
  "development" => {
    :rails_root => "/Users/dan/Sites/tweasier/",
    :log_file   => "/Users/dan/Sites/tweasier/log/god.log",
    :user       => "dan",
    :group      => "staff",
    :workers    => {"*" => {:count => 2, :nice => 12}},
    :interval   => 30.seconds,
    :max_memory => 300.megabytes
  },
  "staging" => {
    :rails_root => "/home/twdeploy/sites/staging.tweasier.com/current",
    :log_file   => "/home/twdeploy/sites/staging.tweasier.com/current/log/god.log",
    :user       => "twdeploy",
    :group      => "twdeploy",
    :workers    => {
      "*" => {:count => 8, :nice => 4},
      "refresh_rate_limit" => {:count => 2, :nice => 10},
      "import_follower_refresh,import_followers_import_friend_refresh,import_friends" => {:count => 2, :nice => 2},
      "scraper" => {:count => 4, :nice => 0}
    },
    :interval   => 30.seconds,
    :max_memory => 300.megabytes
  },
  "production" => {
    :rails_root => "/home/twdeploy/sites/tweasier.com/current",
    :log_file   => "/home/twdeploy/sites/tweasier.com/current/log/god.log",
    :user       => "twdeploy",
    :group      => "twdeploy",
    :workers    => {
      "*" => {:count => 8, :nice => 4},
      "refresh_rate_limit" => {:count => 2, :nice => 10},
      "import_follower_refresh,import_followers_import_friend_refresh,import_friends" => {:count => 2, :nice => 2},
      "scraper" => {:count => 4, :nice => 0}
    },
    :interval   => 30.seconds,
    :max_memory => 300.megabytes
  }
}

config = configs[rails_env]

# Check with "sudo god -D -c config/resque.god"
# Start with "sudo god -c config/resque.god"

# Configuration ends...
config[:workers].each do |queue, prefs|
  worker_count = prefs[:count]
  nice_level = prefs[:nice].to_s
  
  worker_count.times do |num|
    God.watch do |w|
      w.name     = "resque-#{queue.gsub(',','_')}-#{num}"
      w.group    = 'resque'
      w.interval = config[:interval]
      w.env      = { "QUEUE" => queue, "RAILS_ENV" => rails_env, "RESQUE" => "1"}
      w.start    = "nice -n #{nice_level} /usr/bin/rake -f #{config[:rails_root]}/Rakefile environment resque:work"
      w.log      = config[:log_file]
    
      w.uid = config[:user]
      w.gid = config[:group]
    
      # retart if memory gets too high
      w.transition(:up, :restart) do |on|
        on.condition(:memory_usage) do |c|
          c.above = config[:max_memory]
          c.times = 2
        end
      end
    
      # determine the state on startup
      w.transition(:init, { true => :up, false => :start }) do |on|
        on.condition(:process_running) do |c|
          c.running = true
        end
      end
    
      # determine when process has finished starting
      w.transition([:start, :restart], :up) do |on|
        on.condition(:process_running) do |c|
          c.running = true
          c.interval = 5.seconds
        end
      
        # failsafe
        on.condition(:tries) do |c|
          c.times = 5
          c.transition = :start
          c.interval = 5.seconds
        end
      end
    
      # start if process is not running
      w.transition(:up, :start) do |on|
        on.condition(:process_running) do |c|
          c.running = false
        end
      end
    end
  end
end
