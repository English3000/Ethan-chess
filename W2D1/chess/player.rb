require_relative 'cursor'
require_relative 'board'

class HumanPlayer
  attr_reader :color
  attr_accessor :name

  def initialize(name, cursor, color)
    @name = name
    @cursor = cursor
    @color = color
  end

  def play_turn(display)
    # display.render
    # puts "To select a piece, move the cursor to it
    # & hit the spacebar or enter."
    # input = [0, 0]
    # output = @cursor.get_input
    # until input == output #&& board[input].color == current_player.color
    #   display.render
    #   puts "To select a piece, move the cursor to it
    #   & hit the spacebar or enter."
    #   input = output
    #   output = @cursor.get_input
    # end
    # start_pos = input
    #
    # puts "You've selected #{@cursor.board[input].class} at #{input}."
    # puts "Where would you like to move it?"
    #
    # output = @cursor.get_input
    # until input == output
    #   display.render
    #   puts "Select a place to move it."
    #   input = output
    #   output = @cursor.get_input
    # end


    start_pos = get_pos(display, "Select piece to grab")
    end_pos = get_pos(display, "Select place to drop piece")
    [start_pos, end_pos]
  end

  def get_pos(display, message)
    display.render
    puts message
    puts "#{@color.to_s.capitalize}'s turn. Player: #{@name}"
    input = @cursor.get_input
    until input.is_a?(Array)
      display.render
      puts message
      puts "#{@color.to_s.capitalize}'s turn. Player: #{@name}"
      input = @cursor.get_input
    end
    input
  end
end
