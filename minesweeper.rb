# coding: utf-8
require_relative "board"
require_relative "tile"
require_relative "cursor"
require_relative "render"
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
    wipe    
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

    self.endgame
    wipe
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
    until self.board.over?
      [0,1].each do |frame|
        @mutex.synchronize do
          self.board.render frame
        end
        print "\r\nUse I, J, K, L To move about, E to look for informants. "
        print "\r\nType F to 'flag a Commie'. \n"
        print "\r\nType S to save your informant list, D to load your last list, and X if you are ready to give up :("
        sleep(frame_rate)
        wipe
      end
    end

  end


  def title
    wipe
    print "\r\n RED ".colorize(color: :red).blink
    print "Is The Scariest Color"
    sleep(4)
    wipe
  end

  def prologue
    frame_rate = 1.5 / 24.0
    text = "The year is 1951, and Congress has put you in charge of chasing down communist\r\nsympathizers, get them all before they get a chance to flee the country!"
    text_display(text, frame_rate, 2)
  end

  def endgame
    frame_rate = 1.5 / 24.0
    text =  "Looks like a communist discovered your identity before you hunted them all down!\r\nThe rest fled the country and Senator McCarthy personally took notice of you as a possible sympathizer.\r\nThere goes your political career. "
    text_display(text, frame_rate, 6, "" ){self.board.reveal}
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


