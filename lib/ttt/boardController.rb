module TTT
  class BoardController
    attr_reader :current_mover, :game_status

    def initialize(user_side=SIDE_X, states_array=[0,0,0,0,0,0,0,0,0])
      @states = states_array
      @user_side = user_side
      @current_mover = SIDE_X
      @game_status = :Playing
      @board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | 2 | 3 ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
    end

    def next_move(position)
      if position.between?(1, 9) && !position.nil?
        index = position-1 
      else
        raise Errors::InvalidMoveError
      end

      if @states[index] != 0
        raise Errors::InvalidMoveError
      else
        @states[index] = @current_mover
        update_game_status(@current_mover)
        switch_current_mover
      end
    end

    def next_computer_move
      if @gamer_side == @current_mover
        raise Errors::InvalidMoveError
      else
        next_move(calculate_computer_move)
      end
    end

    def calculate_computer_move
      AI.new.generate_next_move(@states)
    end

    def update_game_status(current_mover)
      @game_status = :Playing
      states_array = @states.each_slice(3).to_a
      states_array.each_with_index do |row, row_number|
        if row.count(current_mover) == 3 || states_array.transpose[row_number].count(current_mover) == 3 || [states_array[0][0], states_array[1][1], states_array[2][2]].count(current_mover) == 3|| [states_array[0][3], states_array[1][1], states_array[2][0]].count(current_mover) == 3
          @game_status = current_mover == @user_side ? "You won!" : "You lose!"
        elsif @states.count(0) == 0
          @game_status = "It's a tie"
        end
      end
    end

    def switch_current_mover
      @current_mover = @current_mover == SIDE_X ? SIDE_O : SIDE_X
    end

    def board
      @states.each_with_index do |s, i|
        index_string = (i+1).to_s
        @board.sub!(index_string, s) if BOTH_SIDES.include?(s)
      end
      @board
    end
  end
end