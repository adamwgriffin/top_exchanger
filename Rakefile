require "bundler/gem_tasks"

task :install_gem do
   sh "gem build top_exchanger.gemspec && gem install ./top_exchanger-*.gem"
end

task :test_gem do
  ruby "test/test.rb"
end

task :ready_for_the_day => [:install_gem, :test_gem] do
  puts "Gem built and test run successfully."
end
