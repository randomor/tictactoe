# encoding: utf-8
module TTT
  class BoardController
    attr_reader :current_mover, :game_status, :board_model

    def initialize(states_array=[0,0,0,0,0,0,0,0,0])
      @board_model = states_array
      @current_mover = SIDE_X
      @game_status = :Playing
    end

    def valid_move?(position)
      position = position.to_i if !position.is_a?(Integer)
      @board_model[position-1] == 0
    end

    def next_move(position)
      if !position.nil? && position.between?(1, 9)
        index = position-1 
      else
        raise Errors::InvalidMoveError
      end
      if @board_model[index] != 0
        raise Errors::InvalidMoveError
      else
        @board_model[index] = @current_mover
        update_game_status(@current_mover)
        switch_current_mover
      end
    end

    def render_view
      board_view = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | 2 | 3 ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
      @board_model.each_with_index do |s, i|
        index_string = (i+1).to_s
        board_view.sub!(index_string, s) if BOTH_SIDES.include?(s)
      end
      board_view
    end

    private

      def update_game_status(current_mover)
        states_array = @board_model.each_slice(3).to_a
        states_array.each_with_index do |row, row_number|
          if row.count(current_mover) == 3 || states_array.transpose[row_number].count(current_mover) == 3 || [states_array[0][0], states_array[1][1], states_array[2][2]].count(current_mover) == 3|| [states_array[0][2], states_array[1][1], states_array[2][0]].count(current_mover) == 3
            @game_status = current_mover == SIDE_X ? :X_won : :O_won
          elsif @board_model.count(0) == 0
            @game_status = :Tie
          end
        end
      end

      def switch_current_mover
        @current_mover = @current_mover == SIDE_X ? SIDE_O : SIDE_X
      end
  end
end