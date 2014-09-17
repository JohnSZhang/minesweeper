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
    self.title
    self.prologue
    
    @game_thread = Thread.new{
      while true
        sleep(5)
      end
    }
    
    @main_thread = Thread.new{self.animate_board}
    @input_thread = Thread.new{self.get_input}
    @main_thread.join    
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
        print "\r\nUse I, J, K, L To move about, E to look for informants. "
        print "\r\nType F to 'flag a Commie'. \n"
        print "\r\nType S to save your informant list, D to load your last list, and X if you are ready to give up :("
        sleep(frame_rate)
        system "clear"  
      end
    end
  
  end
  
  
  def title
    system "clear"  
    print "\r\n RED ".colorize(color: :red)
    print "Is The Scariest Color"
    sleep(4)
    system "clear"  
  end
  
  def prologue
    frame_rate = (2.0/24.0)
    display = 0
    string = "The year is 1951, and Congress has put you in charge of chasing down communist\r\nsympathizers, get them before they get a chance to flee the country!".split("")
    string_size = string.length
    display_string = ""
    until display == string_size
      system "clear"  
      display_string << string.shift
      print "\r\n#{display_string}"
      sleep(frame_rate)
      display += 1
    end
    sleep(1)
    system "clear"  
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


