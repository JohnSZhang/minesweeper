class Board

  attr_accessor :grid

  def initialize(size = 9, mines = 20)
    @grid = Array.new(9) { Array.new(9) }
    @size = size
    @mines = mines
    create_grid.set_bombs(@mines)
  end

  def create_grid
    @size.times do |row|
      @size.times do |col|
        self[[row, col]] = Tile.new(self, [row, col])
      end
    end

    self
  end

  def process_tile(pos, move)
    if move == "f"
      grid[pos].flag!
    else
      self[pos].explore
    end
  end

  def []=(pos,value)
    x, y = pos
    grid[x][y] = value
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end


  def over?

    self.win? || self.lose?

  end

  def win?
    self.grid.flatten.select(&:explored?) == @size * @size - @mines
  end

  def lose?
    self.grid.flatten.select { |tile| tile.explored? && tile.bomb? }.count > 0
  end

  def render
    print "   "
    (grid.count).times do |index|
      if (0..grid.count).include?(index)
        print "#{index}  "
      else
        print "  "
      end
    end
    puts
    (grid.count + 2).times{ print "%  " }
    puts
    grid.count.times do |row|
      print "%  "
      grid.count.times do |col|
        print self[[row, col]].render + "  "
      end
      print "%\n"
      puts
    end
    (grid.count + 2).times{ print "%  " }
    puts
    self
  end

  def set_bombs(mines)
    mine_count = mines
    until mine_count == 0
      tile = self.grid.sample.sample
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
        neighbors << self[[(x_cor), (y_cor)]]
      end
    end

    neighbors
  end

end
