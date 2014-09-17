# encoding: utf-8
class Tile
  ICON = {
    bomb: "✈",
    unexplored: ["☭","⚒"],
    flagged: "⚔",
    safe: "⚖",
    1 => "1",
    2 => "2", 
    3 => "3", 
    4 => "4", 
    5 => "5", 
    6 => "6", 
    7 => "7", 
    8 => "8",
  }
  BCOLOR = {
    unexplored: [:cyan, :light_blue]
  }
  COLOR = {
    unexplored: :light_yellow
  }
  attr_accessor :is_bomb, :flagged, :board, :explored, :neighbors, :pos
  def initialize(board, pos)
    self.board = board
    self.explored = false
    self.pos = pos
    self.is_bomb = false
    self.flagged = false
  end

  def set_bomb
    self.is_bomb = true
  end

  def bomb?
    self.is_bomb
  end

  def explored?
    self.explored
  end

  def explore
    return if self.flag?
    self.explored = true
    neighbors = self.get_neighbors
    if neighbors.none?(&:bomb?)
      neighbors.each { |n| n.explore unless n.explored? }
    end
  end

  def flag?
    self.flagged
  end

  def flag!
    self.flagged = !self.flagged unless self.explored?
  end

  def render(frame)
    if flag?
      ICON[:flagged]
    elsif explored?
      return ICON[:bomb] if bomb?
      neighbors = self.get_neighbors
      bombs_count = 0
      neighbors.each do |neighbor|
        bombs_count += 1 if neighbor.bomb?
      end
      if bombs_count == 0
        ICON[:safe]
      elsif bombs_count >= 1
        "#{bombs_count}"
      end
    else
      ICON[:unexplored][frame].colorize(color: COLOR[:unexplored][frame])
    end
  end
  
  def render_title
    
  end

  def get_neighbors
    self.board.neighbors(self.pos)
  end

  def inspect
    "is bomb? #{bomb?} is flagged? #{flag?} at position #{pos}"
  end
end