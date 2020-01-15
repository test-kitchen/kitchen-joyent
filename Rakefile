require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'chefstyle'
require 'rspec/core/rake_task'

desc 'Run RuboCop on the lib directory'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb']
  # don't abort rake on failure
  task.fail_on_error = false
end

desc 'Display LOC stats'
task :loc do
  puts "\n## LOC Stats"
  sh 'countloc -r lib/kitchen'
end

desc 'Run RSpec unit tests'
RSpec::Core::RakeTask.new(:spec)

task :default => [:rubocop, :loc, :spec]
