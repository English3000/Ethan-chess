require_relative "pieces"

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }

    (0..1).each do |row|
      (0..7).each do |col|
        self[[row, col]] = Queen.new(:black, [row, col], self)
      end
    end

    (6..7).each do |row|
      (0..7).each do |col|
        self[[row, col]] = Queen.new(:white, [row, col], self)
      end
    end

    (2..5).each do |row|
      (0..7).each do |col|
        self[[row, col]] = NullPiece.new
      end
    end
  end

  def self.in_bounds?(pos)
    pos.all?{|el| el.between?(0,7)}
  end

  def move_piece(start_pos, end_pos)
    raise ArgumentError if self[start_pos] == nil #.class == NullPiece
    # raise ArgumentError if wrong end_pos
    self[end_pos], self[start_pos] = self[start_pos], self[end_pos]
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, value)
    @grid[pos[0]][pos[1]] = value
  end

end
