module IRWebmachine::Pry
  Nav = Pry::CommandSet.new do
    command "next" do
      throw(:breakout, :next)
    end

    command "prev" do
      if _pry_.binding_stack.size == 1
        _pry_.run_command "exit-all" # last on stack, exit subsession.
      else
        _pry_.binding_stack.pop
        _pry_.run_command "whereami"
      end
    end 
  end
end

IRWebmachine::Pry::Nav.import(Pry.commands)
