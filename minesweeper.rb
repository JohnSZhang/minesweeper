class Minesweeper



end

class Board

  attr_accessor :board

  def initialize(size = 9, mines = 10)
    @board = Array.new(9) { Array.new(9) }
    @size = size
    @mines = mines
    board.each do |row|
      col.each do |tile|
        board[row][tile] = Tile.new
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

end

class Tile
  attr_accessor :type, :flag, :board, :explored, :neighbors
  def initialize(board, type)
    self.board = board
    self.type = type
    self.explored = false
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
end