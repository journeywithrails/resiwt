module Giternal
  class App
    def initialize(base_dir)
      @base_dir = base_dir
    end

    def update
      config.each_repo {|r| r.update }
    end

    def freezify
      config.each_repo {|r| r.freezify }
    end

    def unfreezify
      config.each_repo {|r| r.unfreezify }
    end

    def run(action)
      case action
      when "freeze"
        freezify
      when "unfreeze"
        unfreezify
      else
        send(action)
      end
    end

    def config
      return @config if @config

      config_file = ['config/giternal.yml', '.giternal.yml'].detect do |file|
        File.file? File.expand_path(@base_dir + '/' + file)
      end

      if config_file.nil?
        $stderr.puts "config/giternal.yml is missing"
        exit 1
      end

      @config = YamlConfig.new(@base_dir, File.read(config_file))
    end
  end
end
