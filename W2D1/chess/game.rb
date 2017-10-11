require_relative 'board'
require_relative 'display'
require_relative 'player'

class Game
  attr_reader :chessboard, :display, :player1, :player2, :current_player

  def initialize(player1_name, player2_name)
    @chessboard = Board.new
    @display = Display.new(@chessboard)
    @player1 = HumanPlayer.new(player1_name, @display.cursor, :white)
    @player2 = HumanPlayer.new(player2_name, @display.cursor, :black)
    @current_player = player2
  end

  def play
    until chessboard.checkmate?(current_player.color) # add logic for draw
      current_player = current_player == player1 ? player2 : player1
      begin
        move = current_player.play_turn(@chessboard, @display, @current_player)
        chessboard.move_piece(move.first, move.last)
      rescue
        retry
      end
    end
    puts "#{current_player.name}, you win :)"
  end
end


if __FILE__ == $PROGRAM_NAME
  game = Game.new("p1", "p2")
  game.play
end
