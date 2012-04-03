module IRWebmachine::Pry
  Nav = Pry::CommandSet.new do
    command "next" do
      throw(:breakout, :next)
    end

    command "prev" do 
      _pry_.binding_stack.pop
      _pry_.run_command "whereami"
    end 
  end
end

IRWebmachine::Pry::Nav.import(Pry.commands)
