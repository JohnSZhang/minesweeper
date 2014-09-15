class Minesweeper
  attr_accessor :board
  def initialize
    @board = Board.new.set_bombs.render
  end

  def play
    until self.board.over?
      self.board.render
      print "Pick a coordinate: "
      pick_coordinate = gets.chomp.split(' ')
      x, y = pick_coordinate[1].to_i, pick_coordinate[2].to_i
      self.board.process_tile([x,y], pick_coordinate[0])
    end
  end

end

class Board

  attr_accessor :board

  def initialize(size = 9, mines = 20)
    @board = Array.new(9) { Array.new(9) }
    @size = size
    @mines = mines
    size.times do |row|
      size.times do |tile|
        self.board[row][tile] = Tile.new(self, [row, tile])
      end
    end
    @over
  end

  def process_tile(pos, move)
    if move == "f"
      board[pos[0]][pos[1]].flag
    else
      board[pos[0]][pos[1]].explore
    end
  end


  def over?
    #If there's a mine
    #If explored tiles == total_size - mine_count
    got_bomb = false
    explored_count = 0
    board.count.times do |row|
      board.count.times do |col|
        explored_count += 1 if board[row][col].explored?
        if board[row][col].bomb? && board[row][col].explored?
          got_bomb = true
          break
        end
      end
    end

    if got_bomb == true
      puts "You blew up! Game over!"
      self.render
      return true
    elsif explored_count == @size * @size - @mines
      puts "You cleared all the mines!"
      self.render
      return true
    end

    false
  end

  def render
    print "   "
    (board.count).times do |index|
      if (0..board.count).include?(index)
        print "#{index}  "
      else
        print "  "
      end
    end
    puts
    (board.count + 2).times{ print "%  " }
    puts
    board.count.times do |row|
      print "%  "
      board.count.times do |col|
        print board[row][col].render + "  "
      end
      print "%\n"
      puts
    end
    (board.count + 2).times{ print "%  " }
    puts
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
    self.explored
  end

  def explore
    return if self.flag?
    self.explored = true
    neighbors = self.get_neighbors
    if neighbors.none?{|n| n.bomb?}
      neighbors.each{|n| n.explore unless n.explored? }
    end
  end

  def flag?
    self.flagged
  end

  def flag
    self.flagged = !self.flagged unless self.explored?
  end

  def render
    if flag?
      "F"
    elsif explored?
      return "X" if bomb?
      neighbors = self.get_neighbors
      bombs_count = 0
      neighbors.each do |neighbor|
        bombs_count += 1 if neighbor.bomb?
      end
      if bombs_count == 0
        "_"
      elsif bombs_count >= 1
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