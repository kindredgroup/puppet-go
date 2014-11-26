require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet_blacksmith/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'bundler'
require 'rake/clean'

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
  "test/**/*"
]

CLEAN.include('spec/fixtures/')
CLOBBER.include('.tmp', '.librarian')
PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.send("disable_autoloader_layout")
PuppetLint.configuration.send("disable_quoted_booleans")
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

task :librarian_spec_prep do
   sh "librarian-puppet install --path spec/fixtures/modules"
end

task :spec_prep => :librarian_spec_prep
task :default => [:spec, :lint]
task :validate => :syntax

desc "Run integration tests"
task :integration do
    sh "kitchen test all --destroy=always"
end
