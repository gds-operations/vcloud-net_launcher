require 'cucumber/rake/task'
require 'rspec/core/rake_task'

CUKE_RESULTS = 'results.html'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format html -o #{CUKE_RESULTS} --format pretty --no-source -x"
  t.fork = false
end

RSpec::Core::RakeTask.new(:spec) do |task|
  # Set a bogus Fog credential, otherwise it's possible for the unit
  # tests to accidentially run (and succeed against!) an actual 
  # environment, if Fog connection is not stubbed correctly.
  ENV['FOG_CREDENTIAL'] = 'random_nonsense_owiejfoweijf'
  task.pattern = FileList['spec/vcloud/**/*_spec.rb']
end

RSpec::Core::RakeTask.new('integration') do |t|
  t.pattern = FileList['spec/integration/**/*_spec.rb']
end

task :default => [:integration]
