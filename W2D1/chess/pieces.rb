require_relative 'board'
require "byebug"

class Piece
  attr_accessor :pos
  attr_reader :color, :board

  def initialize(color, pos, board) # pass @type
    @color = color
    @pos = pos
    @board = board
  end

  def to_s
    "X".colorize(@color) # if @type == :x
  end

  def moves
    #should return an array of places a Piece can move to
  end
end


class NullPiece < Piece
  # include Singleton
  attr_reader :color

  def initialize
    @color = :light_black
  end

  def to_s
    " "
  end
end


# Classes that include SlidingPiece in particular need the Board
# so they know to stop sliding when blocked by another piece.
#
# Don't allow a piece to move into a square already occupied by the same color piece,
# or to move a sliding piece past a piece that blocks it.
module SlidingPiece
  MOVES_DIR = {
    linear: [[-1, 0], [1, 0], [0, -1], [0, 1]],
    diag: [[-1, -1], [1, 1], [-1, 1], [1, -1]]
  }

  def moves
    case self.mobility
    when :both
      moves_arr(MOVES_DIR[:linear] + MOVES_DIR[:diag])
    when :diag
      moves_arr(MOVES_DIR[:diag])
    when :linear
      moves_arr(MOVES_DIR[:linear])
    end
  end

  def moves_arr(change_by)
    all_moves = []
    row, col = self.pos
    change_by.each do |change|
      test_spot = [row, col]
      in_bounds = true
      while in_bounds
        test_spot = [test_spot[0] + change[0], test_spot[1] + change[1]]
        if Board.in_bounds?(test_spot)
          if self.board[test_spot].class == NullPiece
            all_moves << test_spot
          elsif self.board[test_spot].color != @color
            all_moves << test_spot
            break
          else
            break
          end
        else
          in_bounds = false
        end
      end
    end
    all_moves
  end

end

class Queen < Piece
  attr_reader :mobility
  include SlidingPiece

  def initialize(*args)
    @mobility = :both
    super
  end
end

class Rook < Piece
  attr_reader :mobility
  include SlidingPiece

  def initialize(*args)
    @mobility = :linear
    super
  end
end

class Bishop < Piece
  attr_reader :mobility
  include SlidingPiece

  def initialize(*args)
    @mobility = :diag
    super
  end
end


module SteppingPiece
end

class King < Piece
  include SteppingPiece

  def initialize(*args)
    @mobility = :both
    super
  end
end

class Knight < Piece
  include SteppingPiece

  def initialize(*args)
    @mobility = :L
    super
  end
end


class Pawn < Piece
  def initialize(*args)
    @mobility = :forward
    super
  end
end
