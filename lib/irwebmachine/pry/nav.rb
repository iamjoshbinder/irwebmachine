module IRWebmachine::Pry
  Nav = Pry::CommandSet.new do
    command("continue") { throw(:breakout, :continue) }
    alias_command "c", "continue"

    command("next") { throw(:breakout, :next) }
    alias_command "n", "next"

    command("prev") { throw(:breakout, :previous) }
    alias_command "p", "prev"
  end
end

IRWebmachine::Pry::Nav.import(Pry.commands)
