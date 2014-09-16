require_relative "board"
require_relative "tile"
require "yaml"
class Minesweeper
  attr_reader :board
  def initialize
    @board = Board.new
  end
  def save
    save = @board.to_yaml
    file = File.open("save_file.txt", "w") << save
    file.close
  end

  def load
    file = File.read("save_file.txt")
    @board = YAML::load(file)
  end

  def play
    until self.board.over?

      self.animate_board
        print "Pick a coordinate: "
        pick_coordinate = gets.chomp.split(' ')
        if pick_coordinate[0] == "s"
          save
          puts "Game was saved! Dont try and cheat the game"
        elsif pick_coordinate[0] == "l"
          load
          puts "Game was loaded!"
        else
          pos = pick_coordinate.drop(1).map{|i| i.to_i}
          self.board.process_tile(pos, pick_coordinate[0])
        end
    end
    self.board.render
    puts "Game Over! *BOOM*" if self.board.lose?
    puts "You cleared all the mines!" if self.board.win?
  end
  
  def animate_board
    Thread.new do
      until self.board.over?
        self.board.render
        sleep(1)
        system "clear"
        self.board.render2
        sleep(1)
        system "clear"
      end
    end
  end
  
end


