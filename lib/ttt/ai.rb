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
      winning_position_for_side(@side)
    end

    def block_opponent
      winning_position_for_side(opponent)
    end

    def create_fork
      #don't play corner for these moves.
      if @board.states == [SIDE_X,0,0,0,SIDE_O,0,0,0,SIDE_X] || @board.states == [SIDE_O,0,0,0,SIDE_O,0,0,0,SIDE_O] || @board.states ==  [0,0,SIDE_X,0,SIDE_O,0,SIDE_X,0,0] || @board.states == [0,0,SIDE_O,0,SIDE_X,0,SIDE_O,0,0]
        return [2, 4, 6, 8].sample 
      end
      forking_position_for_side(@side)
    end

    def block_fork
      forking_position_for_side(opponent)
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

    def forking_position_for_side(side)
      diagonal_line = @board.diagonal_line
      counter_diagonal_line = @board.counter_diagonal_line
      @board.rows.each_with_index do |row, row_number|
        row.each_with_index do |state, column_number|
          next if state != 0
          column = @board.columns[column_number]
          counter = 0
          counter+=1 if column.count(side) == 1 && column.count(0) == 2
          counter+=1 if row.count(side) == 1 && row.count(0) == 2
          counter+=1 if ([[1, 1], [0, 0], [2, 2]].include? [row_number, column_number]) && diagonal_line.count(side) == 1 && diagonal_line.count(0) == 2
          counter+=1 if ([[1, 1], [0, 2], [2, 0]].include? [row_number, column_number]) && counter_diagonal_line.count(side) == 1 && counter_diagonal_line.count(0) == 2
          return row_number*3 + column_number + 1 if counter >= 2
        end
      end
      return nil
    end

    def winning_position_for_side(side)
      diagonal_line = @board.diagonal_line
      counter_diagonal_line = @board.counter_diagonal_line
      @board.rows.each_with_index do |row, row_number|
        row.each_with_index do |state, column_number|
          next if state != 0
          column = @board.columns[column_number]
          if row.count(side) == 2 || column.count(side) == 2
            return row_number*3 + column_number + 1
          end
        end
      end
      if diagonal_line.count(side) == 2
        blank_index = diagonal_line.find_index(0)
        return 5 if blank_index == 1
        return 1 if blank_index == 0
        return 9 if blank_index == 2
      elsif counter_diagonal_line.count(side) == 2
        blank_index = counter_diagonal_line.find_index(0)
        return 5 if blank_index == 1
        return 3 if blank_index == 0
        return 7 if blank_index == 2
      end
      return nil
    end
  end
end