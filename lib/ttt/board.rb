module TTT
  class BoardController
    attr_reader :current_mover

    def initialize(states_array=[0,0,0,0,0,0,0,0,0], first_mover=SIDE_X)
      @states = states_array
      @first_mover = first_mover
      @current_mover = @first_mover
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
      index = position-1 if position.between?(1, 9)
      if @states[index] != 0
        raise Errors::InvalidMoveError
      else
        @states[index] = @current_mover
        switch_current_mover
      end
    end

    def switch_current_mover
      @current_mover = @current_mover == SIDE_X ? SIDE_O : SIDE_X
    end

    def board
      @states.each_with_index do |s, i|
        index_string = (i+1).to_s
        @board.sub!(index_string, s) if [SIDE_X, SIDE_O].include?(s)
      end
      @board
    end
  end
end