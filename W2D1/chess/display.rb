require_relative 'board'
require_relative 'cursor'
require 'colorize'

class Display
  attr_reader :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
    @board[@cursor.cursor_pos]
  end

  def render
    system("clear")
    @board.grid.each_with_index do |row, row_i|
      row.each_index do |col_i|
        square = @board[[row_i, col_i]].to_s
        if @cursor.cursor_pos == [row_i, col_i]
          square = square.on_red
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

# if __FILE__ == $PROGRAM_NAME
# begin
#   board = Board.new
#   display = Display.new(board)
#   board.move_piece([6, 0], [4, 0])
#   # board.move_piece([1, 0], [2, 0])
# # rescue
#   display.render
#   # puts board.checkmate?(:white)
#   p board[[4,0]].moves
#   p board[[4,0]].pos
#   # 10.times do
#   #   display.render
#   #   display.cursor.get_input
#   # end
# end
# end
