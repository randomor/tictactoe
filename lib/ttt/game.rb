module TTT
  class Game
    attr_reader :board_controller, :user_side

    def initialize
      @user_side = SIDE_X
      @exiting = false
    end

    def start
      start_prompt
      get_side_from_user
      start_playing
    end

    def start_playing
      @board_controller = BoardController.new(@user_side)
      if @user_side == SIDE_O
        computer_move
      else
        user_move
      end
    end

    def display_board
      puts @board_controller.board
    end

    def user_move
      next_position = ask_user_for_next_move
      if @exiting
        puts "Exiting Game..."
        return
      end
      user_move_to_position next_position
      if (@board_controller.game_status == :Playing)
        display_board
        computer_move
      else
        display_game_result
      end
    end

    def user_move_to_position(position)
      begin
        @board_controller.next_move(position)
      rescue Errors::InvalidMoveError
        show_invalid_move_prompt
      end
    end

    def display_game_result
      display_board
      puts @board_controller.game_status
    end

    def computer_move
      puts ">Computer's turn:"
      puts "Computer thinking..."
      @board_controller.next_computer_move
      puts "Computer moved."
      display_board
      user_move
    end

    def ask_user_for_next_move
      puts ">Your turn:"
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
      input.to_i
    end

    def show_invalid_move_prompt
      puts "That was not a valid move! Please try again"
      ask_user_for_next_move
    end

    def get_side_from_user
      puts 'Which side would you pick? Type in "x" or "o".'
      input = $stdin.gets.chomp.downcase
      if input.length == 1 && BOTH_SIDES.include?(input)
        @user_side = input
        puts "You picked '#{@user_side}'"
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