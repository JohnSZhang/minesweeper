# encoding: utf-8
class Tile
  ICON = {
    bomb: "✈ ",
    unexplored: ["☭ ","⚒ "],
    flagged: "⚔ ",
    safe: "⚖ ",
    kill_bomb: "☠ ",
    1 => "1 ",
    2 => "2 ",
    3 => "3 ",
    4 => "4 ",
    5 => "5 ",
    6 => "6 ",
    7 => "7 ",
    8 => "8 "
  }
  BCOLOR = {
    unexplored: [:cyan, :light_blue],
    flagged: :red,
    bomb: :red,
    kill_bomb: :light_red,
    safe: :light_green
  }
  COLOR = {
    unexplored: :light_yellow,
    1 => :light_magenta,
    2 => :light_blue,
    3 => :light_green,
    4 => :light_red,
    5 => :red,
    6 => :red,
    7 => :red,
    8 => :red 
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
      ICON[:flagged].colorize(background: BCOLOR[:flagged])
    elsif explored?
      return ICON[:bomb].colorize(background: BCOLOR[:bomb]) if bomb?
      neighbors = self.get_neighbors
      bombs_count = 0
      neighbors.each do |neighbor|
        bombs_count += 1 if neighbor.bomb?
      end
      if bombs_count == 0
        ICON[:safe].colorize(background: BCOLOR[:safe])
      elsif bombs_count >= 1
        ICON[bombs_count].colorize(color: COLOR[bombs_count])
      end
    else
      ICON[:unexplored][frame].colorize(color: COLOR[:unexplored][frame])
    end
  end

  def reveal
    if bomb? && explored?
      return ICON[:kill_bomb].colorize(background: BCOLOR[:kill_bomb])
    elsif bomb?
      return ICON[:bomb].colorize(background: BCOLOR[:bomb]) if bomb?
    else
      neighbors = self.get_neighbors
      bombs_count = 0
      neighbors.each do |neighbor|
        bombs_count += 1 if neighbor.bomb?
      end
      if bombs_count == 0
        ICON[:safe].colorize(background: BCOLOR[:safe])
      elsif bombs_count >= 1
        ICON[bombs_count].colorize(color: COLOR[bombs_count])
      end
    end
  end

  def get_neighbors
    self.board.neighbors(self.pos)
  end

  def inspect
    "is bomb? #{bomb?} is flagged? #{flag?} at position #{pos}"
  end
end