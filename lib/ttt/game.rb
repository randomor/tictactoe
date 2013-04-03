# encoding: utf-8
module TTT
  class Game
    PROMPT_WIDTH = 60
    attr_reader :board_controller, :user_side

    def initialize
      @user_side = @current_player = SIDE_X
      @exiting = false
      @board_controller = BoardController.new
    end

    def start
      start_prompt
      start_playing
    end

    def start_playing
      get_side_from_user
      @board_controller = BoardController.new
      display_board
      until @board_controller.game_status != :Playing || @exiting
        play_next
        display_board unless @exiting
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
      puts @board_controller.render_view
    end

    def user_move
      puts ">Your turn:"
      next_position = ask_user_for_next_move
      if next_position
        @board_controller.next_move next_position
        puts "You moved."
      end
    end

    def display_game_result
      puts "GAME OVER!".center(PROMPT_WIDTH, "=")
      puts game_result_to_user.center(PROMPT_WIDTH, "+")
      puts "GAME OVER!".center(PROMPT_WIDTH, "=")
      replay_game
    end

    def game_result_to_user
      result_string = ''
      case @board_controller.game_status
      when :X_won
        result_string = @user_side == SIDE_X ? "You win!" : "You lose!"
      when :O_won
        result_string = @user_side == SIDE_O ? "You win!" : "You lose!"
      when :Tie
        result_string = "It's a tie!"
      else
        result_string = "Still Playing..."
      end
      result_string
    end

    def replay_game
      puts " "
      puts "How about a reply?".center(PROMPT_WIDTH, "=")
      puts "Type 'n' or 'no' to quit, `y` or 'yes' to replay"
      input = $stdin.gets.downcase.chomp[0]
      if input == 'n'
        @exiting = true
        return
      elsif input == 'y'
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
      @board_controller.next_move calculate_computer_move
      puts "Computer moved."
    end

    def calculate_computer_move
      @ai ||= AI.new
      @ai.generate_next_move(@board_controller.board_model, @current_player)
    end

    def ask_user_for_next_move
      puts "What's your next move? Type in the position(Type 'e' or 'exit' to exit)."
      input = $stdin.gets.chomp.downcase
      if input.chomp[0] == 'e'
        @exiting = true
        return
      end
      input = input.to_i
      if input != 0 && @board_controller.valid_move?(input)
        input
      else
        puts "That was not a valid move! Please try again."
        ask_user_for_next_move
      end
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
      puts <<-PROMPT.gsub(/^\s+/, '')
        | Wanna play Tic-Tac-Toe?
        | Align "x" or "o" to horizontal, vertical or diagonal lines in 3 to win.
      PROMPT
    end
  end
end