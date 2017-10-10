require_relative 'board'
require 'singleton'
require "byebug"

class Piece
  attr_accessor :pos, :board
  attr_reader :moves_dir, :color

  def initialize(color, pos, board)
    @moves_dir = {
      linear: [[-1, 0], [1, 0], [0, -1], [0, 1]],
      diag: [[-1, -1], [1, 1], [-1, 1], [1, -1]],
      knight: [
        [-1, -2], [-1, 2], [-2, -1], [-2, 1],
        [1, -2], [1, 2], [2, -1], [2, 1]
      ]#,
      # pawn: [[0, 1], [0, -1]]
        #[0, 2], [0, -2] on first move
        #[1,1], [1, -1]; [-1, -1], [-1, 1] to take piece
    }

    @color = color
    @pos = pos
    @board = board
  end

  def to_s
    # https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode
    self.type.colorize(@color)
  end

  def valid_moves(all_moves)
    all_moves.select{|move| valid_move?(self.pos, move)}
  end

  def valid_move?(start_pos, end_pos)
    false if self.is_a? NullPiece
    dup_board = self.board.board_dup
    dup_board[end_pos], dup_board[start_pos] = dup_board[start_pos], dup_board[end_pos]
    !dup_board.in_check?(self.color)
  end
end


class NullPiece < Piece
  include Singleton

  def initialize
  end

  def to_s
    "  "
  end
end


# Classes that include SlidingPiece in particular need the Board
# so they know to stop sliding when blocked by another piece.
#
# Don't allow a piece to move into a square already occupied by the same color piece,
# or to move a sliding piece past a piece that blocks it.
module SlidingPiece
  def moves
    case self.mobility
    when :both
      moves_arr(self.moves_dir[:linear] + self.moves_dir[:diag])
    when :diag
      moves_arr(self.moves_dir[:diag])
    when :linear
      moves_arr(self.moves_dir[:linear])
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
  attr_reader :mobility, :type
  include SlidingPiece

  def initialize(*args)
    @mobility = :both
    @type = "\u265B "
    super
  end
end

class Rook < Piece
  attr_reader :mobility, :type
  include SlidingPiece

  def initialize(*args)
    @mobility = :linear
    @type = "\u265C "
    super
  end
end

class Bishop < Piece
  attr_reader :mobility, :type
  include SlidingPiece

  def initialize(*args)
    @mobility = :diag
    @type = "\u265D "
    super
  end
end


module SteppingPiece
  def moves
    case self.mobility
    when :both
      moves_arr(self.moves_dir[:linear] + self.moves_dir[:diag])
    when :knight
      moves_arr(self.moves_dir[:knight])
    end
  end

  def moves_arr(change_by)
    all_moves = []
    row, col = self.pos
    change_by.each do |change|
      test_spot = [self.pos[0] + change[0], self.pos[1] + change[1]]
      if Board.in_bounds?(test_spot)
        if self.board[test_spot].class == NullPiece
          all_moves << test_spot #if self.board.valid_move?(self.pos, test_spot)
        elsif self.board[test_spot].color != @color
          all_moves << test_spot #if self.board.valid_move?(self.pos, test_spot)
        end
      end
    end
    all_moves
  end
end

class King < Piece
  attr_reader :mobility, :type
  include SteppingPiece

  def initialize(*args)
    @mobility = :both
    @type = "\u265A "
    super
  end
end

class Knight < Piece
  attr_reader :mobility, :type
  include SteppingPiece

  def initialize(*args)
    @mobility = :knight
    @type = "\u265E "
    super
  end
end


class Pawn < Piece
  attr_reader :mobility, :type

  def initialize(*args)
    @mobility = :forward
    @type = "\u265F "
    super
  end

  def moves
    []
  end

  def moves_arr
    # pawn: [[0, 1], [0, -1]]
      #[0, 2], [0, -2] on first move
      #[1,1], [1, -1]; [-1, -1], [-1, 1] to take piece
  end
end
