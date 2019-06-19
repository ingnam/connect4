class Player
  attr_accessor :name
  attr_reader   :mark

  def initialize(name:, mark:)
    @name = name
    @mark = mark
  end

  def computer_player?
    name == "Computer Player"
  end
end
