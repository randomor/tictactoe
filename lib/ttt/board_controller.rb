# encoding: utf-8
module TTT
  class BoardController
    attr_reader :current_mover, :game_status, :board_model

    def initialize(board = Board.new)
      @board_model = board
      @current_mover = SIDE_X
      @game_status = :Playing
    end

    def valid_move?(position)
      position = position.to_i if !position.is_a?(Integer)
      @board_model.empty_position? position
    end

    def next_move(position)
      unless !position.nil? && position.between?(1, 9) && valid_move?(position)
        raise Errors::InvalidMoveError
      else
        @board_model[position] = @current_mover
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
      (1..9).to_a.each do |position|
        position_state = @board_model[position]
        board_view.sub!(position.to_s, position_state) if BOTH_SIDES.include?(position_state)
      end
      board_view
    end

    private

      def update_game_status(current_mover)
        rows = @board_model.rows
        columns = @board_model.columns
        diagnoal = @board_model.diagnoal_line
        counter_diagnoal = @board_model.counter_diagnoal_line
        rows.each_with_index do |row, row_number|
          if row.count(current_mover) == 3 || columns[row_number].count(current_mover) == 3 || diagnoal.count(current_mover) == 3 || counter_diagnoal.count(current_mover) == 3
            @game_status = current_mover == SIDE_X ? :X_won : :O_won
          elsif @board_model.full?
            @game_status = :Tie
          end
        end
      end

      def switch_current_mover
        @current_mover = @current_mover == SIDE_X ? SIDE_O : SIDE_X
      end
  end
end