$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Giternal
  
end

require 'giternal/repository'
require 'giternal/yaml_config'
require 'giternal/app'
