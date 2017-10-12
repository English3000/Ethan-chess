require_relative 'board'
require_relative 'display'
require_relative 'player'
require "byebug"

class Game
  attr_reader :chessboard, :display, :player1, :player2, :current_player

  def initialize(player1_name, player2_name)
    @chessboard = Board.new
    @display = Display.new(@chessboard)
    @player1 = HumanPlayer.new(player1_name, @display.cursor, :white)
    @player2 = HumanPlayer.new(player2_name, @display.cursor, :black)
    @current_player = player2
  end

  def start_game
    print "Enter name for white side: "
    @player1.name = gets.chomp

    print "Enter name for black side: "
    @player2.name = gets.chomp

  end

  def play
    start_game
    current_player = player2
    other_player = player1
    until chessboard.checkmate?(other_player.color)
      current_player, other_player = other_player, current_player
      begin
        move = current_player.play_turn(@display)
        # debugger
        chessboard.move_piece(move.first, move.last, current_player.color)
      rescue
        retry
      end
    end
    @display.render
    puts "Checkmate. #{current_player.name} wins!"
  end
end


if __FILE__ == $PROGRAM_NAME
  game = Game.new("p1", "p2")
  game.play
end
