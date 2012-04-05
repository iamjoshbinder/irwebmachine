#!/usr/bin/env rake

begin
  require 'bundler/gem_tasks'
rescue LoadError
  require 'rubygems/package_task'
  Gem::PackageTask.new(eval(IO.read('irwebmachine.gemspec'))) do |pkg|
    pkg.need_tar, pkg.need_zip = true, false
  end
end

require 'rake/testtask'
task :default => :test
Rake::TestTask.new do |t|
  t.name = "test"
  t.test_files = Dir["test/*_test.rb"]
end