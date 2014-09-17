# coding: utf-8
require_relative "board"
require_relative "tile"
require_relative "cursor"
require "yaml"

class Minesweeper
  attr_reader :board, :cursor
  def initialize
    @board = Board.new
    @thread = nil
    @mutex = Mutex.new
    @input
  end
  def save
    save = @board.to_yaml
    file = File.open("game.sav", "w") << save
    file.close
  end

  def load
    file = File.read("game.sav")
    @board = YAML::load(file)
  end

  def play

    system "clear"  
    @game_thread = Thread.new{
      while true
        sleep(5)
      end
    }
    
    @main_thread = Thread.new{self.animate_board}
    @input_thread = Thread.new{self.get_input}
    @main_thread.join    
    
    
    # @input_thread.join
    # until self.board.over?
    #     system "clear"
    #
    #
    #     input = gets.chomp
    #             p @thread.object_id
    #     @thread.stop if input = "e"
    #
    #     # self.input
    #     # if pick_coordinate[0] == "s"
    #     #   save
    #     #   puts "Game was saved! Dont try and cheat the game"
    #     # elsif pick_coordinate[0] == "l"
    #     #   load
    #     #   puts "Game was loaded!"
    #     # else
    #     #   pos = pick_coordinate.drop(1).map{|i| i.to_i}
    #     #   self.board.process_tile(pos, pick_coordinate[0])
    #     # end
    #   end
    #   self.board.render
    #   puts "Game Over! *BOOM*" if self.board.lose?
    #   puts "You cleared all the mines!" if self.board.win?
  end
  
 
  def get_input
    input_frame_rate = 6.0/24.0
      sleep(input_frame_rate)
      system("stty raw -echo")
      input = STDIN.getc.chr
      self.exit_game?(input)
      self.state_change?(input)
      
      @mutex.synchronize do
        self.board.process_move(input)
      end
      @input_thread = Thread.new{self.get_input}
      
  end
  
  def animate_board
    frame_rate = (12.0/24.0)
    until false
      [0,1].each do |frame|
        @mutex.synchronize do
          self.board.render frame
        end
        print "\r\nUse I, J, K, L To Move Direction, E to Explore Current Tile "
        print "\r\nand F to flag current tile \n"
        print "\r\nType S to save game and D to load last save and X to exit"
        sleep(frame_rate)
        system "clear"  
      end
    end
  
  end
  
  
  def render_title
    frame_rate = (12.0/24.0)
    display = 0
    string = "The year is 1951, and you've been charged by the government to chase down communist sympathizers, get them before they get a chance to flee!".to_a
    string_size = string.length
    display_string = ""
    until display == string_size
      system "clear"  
      display_string << string.shift
      print "\r\n#{display_string}"
      sleep(frame_rate)
      display += 1
    end
  end
  
  def exit_game?(input)
    if input == "x"
      @game_thread.kill
      @main_thread.kill
    end
  end
  
  def state_change?(input)
    case 
    when input == "s"
      self.save
    when input == "d"
      self.load
    end
  end
      
   
end


