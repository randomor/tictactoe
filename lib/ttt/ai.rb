module TTT
  class AI
    attr_accessor :states
    def initialize(states=[0,0,0,0,0,0,0,0,0])
      @states = states
      @side = SIDE_X
      @opponent = @side == SIDE_X ? SIDE_O : SIDE_X
    end

    def generate_next_move(states, side)
      @states = states
      picked = states.index(0)+1
      index = pick_last_position || pick_winning_position || block_opponent || create_fork || block_fork || play_center || play_opposite_corner || play_empty_corner || play_empty_side
      picked = index+1      
    end

    def pick_last_position
      return @states.find_index(0) if @states.count(0) == 1
    end

    def pick_winning_index
      winning_position_for_side(@side)
    end

    def block_opponent
      winning_position_for_side(@opponent)
    end

    def create_fork
      forking_position_for_side(@side)
    end

    def block_fork
      forking_position_for_side(@opponent)
    end

    def play_center
      return 4 if @states[4] == 0
    end

    def play_opposite_corner
      return 8 if @states[0] == @opponent && @states[8] == 0
      return 6 if @states[2] == @opponent && @states[6] == 0
      return 2 if @states[6] == @opponent && @states[2] == 0
      return 0 if @states[8] == @opponent && @states[0] == 0
    end

    def play_empty_corner
      [0, 2, 6, 8].find{ |i| @states[i] == 0 }
    end

    def play_empty_side
      [1, 3, 5, 7].find{ |i| @states[i] == 0 }
    end

    def forking_position_for_side(side)
      states_array = @states.each_slice(3).to_a
      diagonal_line = [states_array[0][0], states_array[1][1], states_array[2][2]]
      counter_diagonal_line = [states_array[0][2], states_array[1][1], states_array[2][0]]
      states_array.each_with_index do |row, row_number|
        row.each_with_index do |state, column_number|
          next if state != 0
          column = states_array.transpose[column_number]
          counter = 0
          counter+=1 if column.count(side) == 1 && column.count(0) == 2
          counter+=1 if row.count(side) == 1 && row.count(0) == 2
          counter+=1 if ([[1, 1], [0, 0], [2, 2]].include? [row_number, column_number]) && diagonal_line.count(side) == 1 && diagonal_line.count(0) == 2
          counter+=1 if ([[1, 1], [0, 2], [2, 0]].include? [row_number, column_number]) && counter_diagonal_line.count(side) == 1 && counter_diagonal_line.count(0) == 2
          return row_number*3 + column_number if counter >= 2
        end
      end
    end

    def winning_position_for_side(side)
      states_array = @states.each_slice(3).to_a
      states_array.each_with_index do |row, row_number|
        column = states_array.transpose[row_number]
        diagonal_line = [states_array[0][0], states_array[1][1], states_array[2][2]]
        counter_diagonal_line = [states_array[0][2], states_array[1][1], states_array[2][0]]
        if row.count(side) == 2
          blank_index = row.find_index(0)
          return row_number*3 + blank_index
        elsif column.count(side) == 2
          blank_index = column.find_index(0)
          return blank_index*3 + row_number
        elsif diagonal_line.count(side) == 2
          blank_index = diagonal_line.find_index(0)
          return 4 if blank_index == 1
          return 0 if blank_index == 0
          return 8 if blank_index == 2
        elsif counter_diagonal_line.count(side) == 2
          blank_index = counter_diagonal_line.find_index(0)
          return 4 if blank_index == 1
          return 2 if blank_index == 0
          return 6 if blank_index == 2
        end
      end
    end
  end
end