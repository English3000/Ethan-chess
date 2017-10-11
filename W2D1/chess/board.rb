require_relative "pieces"
require "byebug"

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }

    generate_pieces_row = Proc.new do |color, row, board|
      [
        Rook.new(color, [row, 0], board),
        Knight.new(color, [row, 1], board),
        Bishop.new(color, [row, 2], board),
        Queen.new(color, [row, 3], board),
        King.new(color, [row, 4], board),
        Bishop.new(color, [row, 5], board),
        Knight.new(color, [row, 6], board),
        Rook.new(color, [row, 7], board)
      ]
    end

    generate_pawn_row = Proc.new do |color, row, board|
      ret_val = []
      8.times do |col|
        ret_val << Pawn.new(color, [row, col], board)
      end
      ret_val
    end

    [1, 6].each do |row|
      row_color = row == 6 ? :white : :black
      @grid[row] = generate_pawn_row.call(row_color, row, self)
    end

    [0, 7].each do |row|
      row_color = row == 7 ? :white : :black
      @grid[row] = generate_pieces_row.call(row_color, row, self)
    end

    (2..5).each do |row|
      (0..7).each do |col|
        self[[row, col]] = NullPiece.instance
      end
    end
  end

  def self.in_bounds?(pos)
    pos.all?{|el| el.between?(0,7)}
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].valid_move?(start_pos, end_pos)
      self[end_pos], self[start_pos] = self[start_pos], self[end_pos]
      self[end_pos].pos = end_pos
      # self.convert if self.is_a?(Pawn)
    else
      puts "Invalid move."
      raise ArgumentError, "Invalid move."
    end
  end

  def board_dup
    dup_board = self.dup
    dup_board.grid = self.grid.deeper_dup #dup'd piece ref's (to the orig. board)?
    dup_board.update_refs
    dup_board
  end

  def update_refs
    self.grid.each_index do |row_i|
      self.grid[row_i].each do |piece|
        piece.board = self
      end
    end
  end

  def in_check?(color)
    @grid.each_index do |row_i|
      @grid[row_i].each do |piece|
        next if piece.class == NullPiece || piece.color == color
        return true if piece.moves.any? do |pos|
          self[pos].class == King && self[pos].color == color
        end
      end
    end
    false
  end

  def checkmate?(color)
    @grid.each_index do |row_i|
      @grid[row_i].each do |piece|
        next if piece.class == NullPiece || piece.color != color
        return false unless piece.valid_moves(piece.moves).empty?
      end
    end
    true
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, value)
    @grid[pos[0]][pos[1]] = value
  end

end


class Array
  def deeper_dup
    ret_val = []
    self.each do |el|
      if el.is_a?(Array)
        ret_val << el.deeper_dup
      else
        if el.is_a?(NullPiece)
          ret_val << el
        else
          ret_val << el.dup
        end
      end
    end
    ret_val
  end
end
