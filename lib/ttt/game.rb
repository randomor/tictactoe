# encoding: utf-8
module TTT
  class Game
    PROMPT_WIDTH = 60
    attr_reader :board_controller, :user_side

    def initialize
      @user_side = @current_player = SIDE_X
      @exiting = false
      @board_controller = BoardController.new(@user_side)
    end

    def start
      start_prompt
      start_playing
    end

    def start_playing
      get_side_from_user
      @board_controller = BoardController.new(@user_side)
      display_board
      until @board_controller.game_status != :Playing || @exiting
        play_next
      end
      display_game_result unless @exiting
    end

    def play_next
      if @current_player == @user_side
        user_move
      else
        computer_move
      end
      switch_current_player
    end

    def switch_current_player
      @current_player = @current_player == SIDE_X ? SIDE_O : SIDE_X
    end

    def display_board
      puts @board_controller.board
    end

    def user_move
      next_position = ask_user_for_next_move
      if next_position
        user_move_to_position next_position
        display_board
      end
    end

    def user_move_to_position(position)
      begin
        @board_controller.next_move(position)
      rescue Errors::InvalidMoveError
        show_invalid_move_prompt
        user_move
      end
    end

    def display_game_result
      display_board   #TODO move it to the bottom of the method
      status = @board_controller.game_status
      puts "GAME OVER!".center(PROMPT_WIDTH, "=")
      puts status.center(PROMPT_WIDTH, "+")
      puts "GAME OVER!".center(PROMPT_WIDTH, "=")
      replay_game
    end

    def replay_game
      puts " "
      puts "How about a reply?".center(PROMPT_WIDTH, "=")
      puts "Type 'n' or 'no' to quit, type in `y` or 'yes' to replay"
      input = $stdin.gets
      if input != nil && (input.downcase.chomp[0] == 'n')
        @exiting = true
        return
      end
      if input != nil && (input.downcase.chomp[0] == 'y')
        start_playing
      else
        puts "I could not understand that."
        replay_game
      end
    end

    def computer_move
      puts ">Computer's turn"
      puts "Computer thinking..."
      sleep(1) unless ENV['TTT_ENV']
      @board_controller.next_computer_move
      puts "Computer moved."
      display_board
    end

    def ask_user_for_next_move
      puts ">Your turn:"
      puts "What's your next move? Type in the position(Type 'exit' or 'e' to exit)."
      input = $stdin.gets
      if input != nil && (input.downcase.chomp[0] == 'e')
        @exiting = true
        return
      end
      if input != nil && input.chomp!.length == 1 && @board_controller.valid_move?(input.to_i)
        input
      else
        show_invalid_move_prompt
        input = ask_user_for_next_move
      end
      input.to_i
    end

    def show_invalid_move_prompt
      puts "That was not a valid move! Please try again."
    end

    def get_side_from_user
      puts 'Which side would you pick? Type in "x" or "o". "x" moves first.'
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
      $stdout.puts <<-PROMPT.gsub(/^\s+/, '')
        | Wanna play Tic-Tac-Toe?
        | Align "x" or "o" to horizontal, vertical or diagonal lines in 3 to win.
      PROMPT
    end
  end
end