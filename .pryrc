require "webmachine"
require "./lib/irwebmachine"
require "./lib/irwebmachine/pry"
require "./test/fixtures/resource.rb"
IRWebmachine.app = Resource
