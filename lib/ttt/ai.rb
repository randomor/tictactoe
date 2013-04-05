# encoding: utf-8
module TTT
  class AI
    attr_accessor :board, :side
    def initialize(board=Board.new([0,0,0,0,0,0,0,0,0]))
      @board = board
      @side = SIDE_X
    end

    def opponent
      @side == SIDE_X ? SIDE_O : SIDE_X
    end

    def generate_next_move(board, side)
      @board = board
      @side = side
      #Strategy: http://en.wikipedia.org/wiki/Tic-tac-toe
      position = pick_last_position || pick_winning_position || block_opponent || create_fork || block_fork || play_center || play_opposite_corner || play_empty_corner || play_empty_side
    end

    def pick_last_position
      return @board.last_empty_position
    end

    def pick_winning_position
      @board.winning_position_for_side(@side)
    end

    def block_opponent
     @board.winning_position_for_side(opponent)
    end

    def create_fork
      @board.forking_position_for_side(@side)
    end

    def block_fork
      @board.forking_position_for_side(opponent)
    end

    def play_center
      return 5 if @board[5] == 0
    end

    def play_opposite_corner
      return 9 if @board[1] == opponent && @board[9] == 0
      return 7 if @board[3] == opponent && @board[7] == 0
      return 3 if @board[7] == opponent && @board[3] == 0
      return 1 if @board[9] == opponent && @board[1] == 0
    end

    def play_empty_corner
      [1, 3, 7, 9].find{ |i| @board[i] == 0 }
    end

    def play_empty_side
      [2, 4, 6, 8].find{ |i| @board[i] == 0 }
    end
  end
end