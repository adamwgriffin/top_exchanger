require "bundler/gem_tasks"

task :install_gem do
   sh "gem build top_exchanger.gemspec && gem install ./top_exchanger-*.gem"
end

task :test_gem do
  top_producer_file = File.join(File.dirname(File.expand_path(__FILE__)), "test", "export", "tp_export-partial.csv")
  office365_export_file = File.join(File.dirname(File.expand_path(__FILE__)), "export_test.csv")
  ruby "test/topex.rb #{top_producer_file} #{office365_export_file}"
end

task :ready_for_the_day => [:install_gem, :test_gem] do
  puts "Gem built and test run successfully."
end
