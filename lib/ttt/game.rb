module TTT
  class Game
    attr_reader :boardController, :side

    def initialize
      @side = SIDE_X
      @exiting = false
    end

    def start
      start_prompt
      get_side_from_user
      start_playing
    end

    def start_playing
      @board_controller = BoardController.new(@side)
      if @side == SIDE_O
        computer_move
      end
      until (@board_controller.game_status != :Playing) || @exiting
        display_board
        ask_user_for_next_move 
      end
      display_game_result unless @exiting
    end

    def display_board
      puts @board_controller.board
    end

    def computer_move

    end

    def ask_user_for_next_move
      puts "What's your next move? Type in the position.(Type 'exit' to quit)"
      input = $stdin.gets
      if input != nil && (input.chomp == 'exit')
        @exiting = true
        return
      end
      if input != nil && input.length != 1
        input = input.chomp.downcase 
      else
        show_invalid_move_prompt
        return
      end
      begin
        @board_controller.next_move(input.to_i)
      rescue Errors::InvalidMoveError
        show_invalid_move_prompt
      end
    end

    def show_invalid_move_prompt
      puts "That was not a valid move! Please try again"
      ask_user_for_next_move
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