class Minesweeper
  attr_accessor :board
  def initialize
    @board = Board.new.set_bombs.render
  end

end

class Board

  attr_accessor :board

  def initialize(size = 9, mines = 10)
    @board = Array.new(9) { Array.new(9) }
    @size = size
    @mines = mines
    size.times do |row|
      size.times do |tile|
        self.board[row][tile] = Tile.new(self, [row, tile])
      end
    end

  end

  def render
    board.count.times do |row|
      board.count.times do |col|
        print board[row][col].render
      end
      print "\n"
    end
    self
  end

  def set_bombs
    mine_count = @mines
    until mine_count == 0
      tile = board.sample.sample
      unless tile.bomb?
        tile.set_bomb
        mine_count -= 1
      end
    end

    self
  end

  def neighbors(pos)
    neighbors = []
    moves = [-1,0,1]
    moves.each do |x|
      moves.dup.each do |y|
        x_cor, y_cor = pos[0] + x, pos[1] + y
        next if [x,y] == [0,0] || [x_cor ,y_cor].any?{|n| !(0...@size).include?(n)}
        neighbors << board[(x_cor)][(y_cor)]
      end
    end
    neighbors
  end

end

class Tile
  attr_accessor :type, :flagged, :board, :explored, :neighbors, :pos
  def initialize(board, pos)
    self.board = board
    self.explored = false
    self.pos = pos
    self.type = "harmless"
    self.flagged = false
  end

  def set_bomb
    self.type = "bomb"
  end

  def bomb?
    type == "bomb"
  end

  def explored?
    explored
  end

  def flag?
    flagged
  end

  def flag
    flagged = !flagged
  end

  def render
    if flag?
      "F"
    elsif explored?
      return "X" if bomb?
      neighbors = self.get_neighbors
      bombs_count = neighbors.inject(0) {|ini, n| ini += 1 if n.bomb?}
      if bombs_count == 0
        "_"
      else bombs_count >= 1
        "#{bombs_count}"
      end
    else
      "*"
    end
  end

  def get_neighbors
    self.board.neighbors(self.pos)
  end
  def inspect
    "is bomb? #{bomb?} is flagged? #{flag?} at position #{pos}"
  end
end