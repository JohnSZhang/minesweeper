class Minesweeper
  def initialize
    @board = Board.new.set_bombs
  end

end

class Board

  attr_accessor :board

  def initialize(size = 9, mines = 10)
    @board = Array.new(9) { Array.new(9) }
    @size = size
    @mines = mines
    board.each do |row|
      col.each do |tile|
        board[row][tile] = Tile.new(self, [row, tile])
      end
    end
  end

  def render
    self.each do |row|
      row.each do |col|
        print self[row][col].render
      end
      print "\n"
    end
  end

  def set_bombs
    mine_count = self.mines
    until mine_count == 0 do
      board.sample do |row|
        row.sample do |tile|
          if tile.bomb?
            next
          else
            tile.set_bomb
            count -= 1
          end
        end
      end
    end
  end

  def neighbors(pos)
    neighbors = []
    moves = [-1,0,1]
    moves.each do |x|
      moves.each do |y|
        next if x == 0 and y == 0
        unless board[pos[0] + x][pos[1] + y].nil?
          neighbors << board[pos[0] + x][pos[1] + y]
        end
      end
    end
    neighbors
  end

end

class Tile
  attr_accessor :type, :flag, :board, :explored, :neighbors, :pos
  def initialize(board, pos)
    self.board = board
    self.explored = false
    self.pos = pos
    self.type = "harmless"
  end

  def set_bomb
    type = "bomb"
  end

  def bomb?
    type == "bomb"
  end

  def flag?
    flag
  end

  def flag
    flag = !flag
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
end