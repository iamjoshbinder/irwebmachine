module IRWebmachine::IRB
  require 'irb'
  require_relative "irb/bundle"
end

module IRB::ExtendCommandBundle
  include IRWebmachine::IRB::Bundle
end
