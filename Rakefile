require "bundler/gem_tasks"

require 'rake/clean'
require 'rake/version_task'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  # Put spec opts in a file named .rspec in root
end

Rake::VersionTask.new

task :doc => [ 'doc:clean', 'doc:api' ]

CLOBBER << "doc"
CLEAN << "doc"
namespace :doc do
  require 'yard'
  YARD::Rake::YardocTask.new(:api) do |t|
    t.files = ['lib/**/*.rb']
    t.options = [
      '--output-dir', 'doc/api',
      '--markup', 'markdown'
    ]
  end

  desc 'Remove YARD Documentation'
  task :clean do
    system("rm -rf #{File.dirname(__FILE__)}/doc/api")
  end
end

task :default => [:spec]
