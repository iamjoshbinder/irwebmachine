require "bundler/setup"
require "webmachine"
require "irwebmachine"
require "json"
require "test/unit"
Dir["test/fixtures/*.rb"].each do |file|
  require "./#{file}"
end
