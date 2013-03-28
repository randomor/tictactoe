module TTT
  class Game
    attr_reader :boardController, :side

    def initialize(boardController=BoardController.new)
      @boardController  = boardController
      @side   = SIDE_X
    end

    def start
      start_prompt
      get_side_from_user
      display_board
    end

    def display_board
      puts @boardController.board
    end

    def get_side_from_user
      puts 'Which side would you pick? Type in "x" or "o".'
      input = $stdin.gets.chomp.downcase
      if input.length == 1 && BOTH_SIDES.include?(input)
        @side = input
        puts "You picked '#{@side}'"
      else
        puts 'Invalid pick, pick again please.'
        get_side_from_user
      end
    end

    def start_prompt
      $stdout.puts <<-PROMPT
        | Wanna play Tic-Tac-Toe?
        | Align "x" or "o" to horizontal, vertical or diagonal lines in 3 to win.
        | "X" always go first.
      PROMPT
    end
  end
end