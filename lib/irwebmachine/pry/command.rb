#
# I'm not a fan of the Pry "create_command(…) { }" API/DSL.
# I prefer a vanilla Ruby class-based approach(each command being an 
# obvious subclass).
#
# Pry doesn't support this approach directly so this base class makes our life 
# a little easier.
#
class IRWebmachine::Pry::Command < Pry::ClassCommand
  def self.name(name=nil)
    @name = name if name
    @name
  end
end
