require_relative 'cursor'
require_relative 'board'

class HumanPlayer
  attr_reader :name, :color

  def initialize(name, cursor, color)
    @name = name
    @cursor = cursor
    @color = color
  end

  def play_turn(board, display, current_player)
    display.render
    puts "To select a piece, move the cursor to it
    & hit the spacebar or enter."
    input = [0, 0]
    output = @cursor.get_input
    until input == output #&& board[input].color == current_player.color
      display.render
      puts "To select a piece, move the cursor to it
      & hit the spacebar or enter."
      input = output
      output = @cursor.get_input
    end
    start_pos = input

    puts "You've selected #{@cursor.board[input].class} at #{input}."
    puts "Where would you like to move it?"

    output = @cursor.get_input
    until input == output
      display.render
      puts "Select a place to move it."
      input = output
      output = @cursor.get_input
    end
    end_pos = input
    [start_pos, end_pos]
  end
end
