# A simple alternative to autotest that isnt painful

options = {
  :test_all => true,
  :options => "--require 'spec/spec_helper' --format nested --color",
  :binary => "script/spec"
}

watch("(app|spec)/(.*)\.rb") do |match|
  %x[ clear ]
  
  opts   = options[:options]
  binary = options[:binary]
  
  if options[:test_all]
    files = []
    
    %w{ controllers models helpers views libraries presenters }.each do |dir|
      ["spec/#{dir}/*/*/*.rb", "spec/#{dir}/*/*.rb", "spec/#{dir}/*.rb"].each do |glob|
        Dir.glob(glob).each { |file| files << file }
      end
    end
    
    puts "- Found:"
    files.each { |f| puts "+ #{f}" }
    puts ""
    command = "#{binary} #{files.collect! { |f| File.expand_path(f) }.join(" ")} #{opts}"
  else
    file = match.to_s
    
    puts "", "- Running specs for: #{file}", ""
    
    command = "#{binary} #{file} #{opts}"
  end
  
  system(command)
  
end
