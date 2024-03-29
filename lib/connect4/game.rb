require 'pry'

class Game
  attr_reader :board, :printer, :judge, :players

  def initialize(players)
    @board   = Board.new(self)
    @printer = board.printer
    @judge   = Judge.new(self, board)
    @players = players
  end

  def start
    players_turns
  rescue Interrupt
    exit_game
  end

  def retry_turn(player)
    column = ask_for_column(player, print_board: false)
    board.place_mark_in_column(column, player)
    judge.check_for_winner(player)
  end

  def try_again
    loop do
      case STDIN.gets.chomp.downcase
      when "y" then restart
      when "n" then exit_game
      else type_yes_or_no
      end
    end
  end

  private

  def players_turns
    loop do
      players.each do |player|
        if player.computer_player?
          column = rand 0..6

          unless board.column_available?(column)
            column = rand 0..6
          end
        else
          column = ask_for_column(player)
        end
        board.place_mark_in_column(column, player)
        judge.check_for_winner(player)
      end
    end
  end

  def ask_for_column(player, print_board: true)
    printer.print_board if print_board
    puts "#{player.name}, enter column number you want to move:"
    check_inputted_column
  end

  def check_inputted_column
    loop do
      input = STDIN.gets.chomp

      return input.to_i - 1 if input =~ /^[1-7]$/
      exit_game             if input == "exit".downcase

      printer.print_board
      puts "'#{input}' is not a correct column.\n\nEnter column number you want to move:"
    end
  end

  def type_yes_or_no
    printer.print_board
    puts "Please type 'y' or 'n'."
  end

  def restart
    board.reset
    start
  end

  def exit_game
    system "clear" or system "cls"
    puts "Thanks for playing. Hope you liked it!\n\n"
    exit
  end
end
