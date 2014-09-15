require_relative "board"
require_relative "tile"
class Minesweeper
  attr_reader :board
  def initialize
    @board = Board.new
  end

  def play
    until self.board.over?
      self.board.render
      print "Pick a coordinate: "
      pick_coordinate = gets.chomp.split(' ')
      pos = pick_coordinate.drop(1).map{|i| i.to_i}
      self.board.process_tile(pos, pick_coordinate[0])
    end
    self.board.render
    puts "Game Over! *BOOM*" if self.board.lose?
    puts "You cleared all the mines!" if self.board.win?
  end

end

