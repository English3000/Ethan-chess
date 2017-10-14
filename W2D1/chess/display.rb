require_relative 'board'
require_relative 'cursor'
require 'colorize'

class Display
  attr_reader :cursor, :board

  def initialize(board)
    @board = board
    @cursor = Cursor.new([6,4], board)
    @greens = []
    @blues = []
    @board[@cursor.cursor_pos]
  end

  def set_grabbed(pos)
    if pos == nil
      @greens = []
      return false
    end
    @greens = @board[pos].moves
  end

  def set_blue(pos_arr)
    if pos_arr == nil
      @blues = []
      return false
    end
    @blues = pos_arr
  end

  def render
    system("clear")
    @board.grid.each_with_index do |row, row_i|
      row.each_index do |col_i|
        square = @board[[row_i, col_i]].to_s
        if @cursor.cursor_pos == [row_i, col_i]

          # cursor spot
          if @greens.include?([row_i, col_i])
            square = square.on_light_blue
          elsif @blues.include?([row_i, col_i])
            square = square.on_blue
          else
            square = square.on_red
          end

        elsif @greens.include?([row_i, col_i])

          #green spot
          if (row_i + col_i) % 2 == 0
            square = square.on_green
          else
            square = square.on_light_green
          end

          # other spot
        elsif (row_i + col_i) % 2 == 0
          square = square.on_light_black
        else
          square = square.on_light_white
        end
        print square
      end
      print "\n"
    end
  end

end
