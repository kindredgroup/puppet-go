require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'bundler'
require 'rake/clean'

Bundler.require(:rake)
Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ["spec/**/*.pp", "vendor/**/*.pp", "test/**/*.pp"]
  config.log_format = '%{path}:%{linenumber}:%{KIND}: %{message}'
  config.disable_checks = ["class_inherits_from_params_class", "80chars", "autoloader_layout"]
end

CLEAN.include('spec/fixtures/')
CLOBBER.include('.tmp', '.librarian')

task :librarian_spec_prep do
   sh "librarian-puppet install --path spec/fixtures/modules"
end

task :spec_prep => :librarian_spec_prep

task :default => [:spec]

desc "Validate manifests, templates, and ruby files"
task :validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['spec/**/*.rb','lib/**/*.rb','test/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end
