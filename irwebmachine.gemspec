# -*- encoding: utf-8 -*-
require File.expand_path('../lib/irwebmachine/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rob Gleeson"]
  gem.email         = ["rob@flowof.info"]
  gem.description   = %q{Write a gem description}
  gem.summary       = %q{Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "irwebmachine"
  gem.require_paths = ["lib"]
  gem.version       = IRWebmachine::VERSION

  gem.add_runtime_dependency "uri-query_params", "~> 0.7.0"
  gem.add_runtime_dependency "graph", "~> 2.5.0"
end
