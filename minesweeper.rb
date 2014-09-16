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

    # unless false
    #   move = self.animate_board
    #   puts "animate_board finished"
    #   begin
    #     system("stty raw -echo")
    #     input = STDIN.getc
    #   ensure
    #     system("stty -raw echo")
    #   end
    #   p input      #
    #   # p Thread.main
    #
    # end
    @game_thread = Thread.new{
      unless self.game.over?
      end
    }
    @main_thread = Thread.new{self.animate_board}


    @input_thread = Thread.new{self.get_input}
    @main_thread.join
    @input_thread.join
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
  
  def input
    #    # Input parsing method From https://gist.github.com/acook/4190379
    #        p self.board.object_id
    #    input = STDIN.getc.chr
    #    p input
    #
    #    self.board.process_move(input)
  end
  def get_input
    sleep(6.0/24.0)
    until self.board.over?

      sleep(12.0/24.0)
      system("stty raw -echo")
      input = STDIN.getc
      @mutex.synchronize do
        self.board.process_move(input)
      end
      #   self.board.render 0
      #   # if input == "x"
      # #     @game_thread.kill
      # #     @other_thread.kill
      # #     @input_thread.kill
      # #   end
      #
    end
  end
  
  def animate_board
    frame_rate = (12.0/24.0)
    
    until self.board.over?
      [0,1].each do |frame|
        @mutex.synchronize do
          self.board.render frame
        end
        print "\r\nUse Arrow Keys To Move, E to Explore Current Tile "
        print "\r\nand F to flag current tile \n"
        print "\r\nType S to save game and L to load last save"
        sleep(frame_rate)
        system "clear"  
      end
    end
  
  end
   
end


