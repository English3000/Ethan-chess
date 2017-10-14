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
    #find my pieces
    my_color_spots = display.board.spots_with_color(@color)
    display.set_blue(my_color_spots) #turn them blue if cursor on them

    # get piece to grab
    start_pos = get_pos(display, "Select piece to grab")

    # start over if wrong color
    play_turn if display.board[start_pos].color != @color
    display.set_blue(nil) #reset blue spots to empty

    display.set_grabbed(start_pos) #set valid move locations to green
    end_pos = get_pos(display, "Select place to drop piece")
    display.set_grabbed(nil)
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
