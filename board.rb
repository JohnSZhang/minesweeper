require "colorize"
class Board

  attr_accessor :grid
  attr_reader :size, :cursor
  def initialize(size = 9, mines = 20 )
    @grid = Array.new(9) { Array.new(9) }
    @size = size
    @mines = mines
    @cursor = Cursor.new([rand(size), rand(size)])
    
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
  # Arrow parsing method From https://gist.github.com/acook/4190379
  # def process_move(move)
  #   p "process move is called"
  #   p move
  #   cursor_pos = self.cursor.position
  #   p cursor_pos
  #   case move
  #   when "E" || "e"
  #     self[cursor_pos].explore
  #   when "F" || "f"
  #     self[cursor_pos].flag!
  #   # when "\e[A"
  #   # when "\e[B"
  #   # when "\e[C"
  #   # when "\e[D"
  #   end
  # end
  
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

  def render(f)
    border = ["$", "%"]
    cursor = [:light_cyan, :light_white ]
    print "\r\n  "
    (grid.count).times do |index|
      if (0..grid.count).include?(index)
        print "#{index}  "
      else
        print "  "
      end
    end
    print "\r\n"
    (grid.count + 2).times{ print "#{border[f]}  " }
    grid.count.times do |row|
      print "\r\n#{border[f]}  "
      grid.count.times do |col|
        tile = self[[row, col]]
        if tile.pos == self.cursor.position
          print (tile.render + " ").colorize(:background => cursor[f])
        else
          print (tile.render + " ")
        end
      end
      print "#{border[f]}\n"
    end
    print "\r\n"
    (grid.count + 2).times{ print "#{border[f]}  " }
    self
  end
  
  def render_border
  end
  
  def render_row
  end
  
  def render_tile
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
