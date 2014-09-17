# encoding: utf-8
require "colorize"
class Board

  attr_accessor :grid
  attr_reader :size, :cursor
  def initialize(size = 9, mines = 16 )
    @grid = Array.new(9) { Array.new(9) }
    @size = size
    @mines = mines
    @cursor = Cursor.new([rand(size), rand(size)], [@size, @size])
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
  def process_move(move)

    cursor_pos = self.cursor.position
    case
    when ["e","E"].include?(move)
      self[cursor_pos].explore
    when ["f","F"].include?(move)
      self[cursor_pos].flag!
    when move == "k"
      self.cursor.move("down")
    when move == "i"
      self.cursor.move("up")
    when  move =="j"
      self.cursor.move("left")
    when move == "l"
      self.cursor.move("right")
    end
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

  def render(f)
    cursor = [:light_cyan, :light_white ]
    self.grid.count.times do |row|

      self.grid.count.times do |col|
        tile = self[[row, col]]
        if tile.pos == self.cursor.position
          print (tile.render(f).colorize(:background => cursor[f]))
        else
          print (tile.render(f))
        end
      end
      print "\r\n"
    end
    self
 end

 def reveal
   self.grid.each do |row|
     row.each {|tile| print(tile.reveal)}
     print "\r\n"
   end
   self
 end
end
