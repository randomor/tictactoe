module TTT
  class Game
    attr_reader :boardController, :side

    def initialize(boardController=BoardController.new)
      @boardController  = boardController
      @side             = SIDE_X
    end

    def start
      start_prompt
      get_side_from_user
      display_board
    end

    def start_playing
      if @boardController.game_status != :Playing
        display_game_result
      else
        display_board
        ask_for_next_move 
      end
    end

    def display_board
      puts @boardController.board
    end

    def ask_for_next_move
      puts "What's your next move? Type in the position"
      input = $stdin.gets
      if input != nil && input.length != 1
        input = input.chomp.downcase 
      else
        show_invalid_move_prompt
        return
      end
      begin
        @boardController.next_move(input.to_i)
      rescue Errors::InvalidMoveError
        show_invalid_move_prompt
      end
    end

    def show_invalid_move_prompt
      puts "That was not a valid move! Please try again"
      ask_for_next_move
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
        | "x" always go first.
      PROMPT
    end
  end
end