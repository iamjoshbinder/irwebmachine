module IRWebmachine::Pry
  Nav = Pry::CommandSet.new do
    command "continue" do
      throw(:breakout, :continue)  
    end

    command "next" do
      throw(:breakout, :next)
    end

    command "prev" do
      throw(:breakout, :prev) 
    end 
  end
end

IRWebmachine::Pry::Nav.import(Pry.commands)
