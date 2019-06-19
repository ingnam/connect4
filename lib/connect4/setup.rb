class Setup
  attr_accessor :human_player, :computer_player
  attr_reader   :players, :game, :printer, :board

  def initialize
    @human_player = Player.new(name: "Human Player", mark: "X")
    @computer_player = Player.new(name: "Computer Player", mark: "O")
    @players = [human_player, computer_player]
    @game    = Game.new(players)
    @printer = game.printer
    @board   = game.board
  end

  def perform
    ask_players_names
    game.start
  rescue Interrupt
    game.exit_game
  end

  private

  def ask_players_names
    printer.print_board
    puts "Please enter your name:"
    human_player.name = STDIN.gets.chomp
  end
end
