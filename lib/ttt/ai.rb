module TTT
  class AI
    attr_accessor :states
    def initialize(states=[0,0,0,0,0,0,0,0,0])
      @states = states
      @side = SIDE_X
    end

    def generate_next_move(states, side)
      @states = states
      picked = states.index(0)+1
      index = pick_last_position || pick_winning_position 
      picked = index+1 if index      
    end

    def pick_last_position
      # return @states.find_index(0) if @states.count(0) == 1
    end

    def pick_winning_index
      states_array = @states.each_slice(3).to_a
      states_array.each_with_index do |row, row_number|
        column = states_array.transpose[row_number]
        diagonal_line = [states_array[0][0], states_array[1][1], states_array[2][2]]
        counter_diagonal_line = [states_array[0][2], states_array[1][1], states_array[2][0]]
        if row.count(@side) == 2
          blank_index = row.find_index(0)
          return row_number*3 + blank_index
        elsif column.count(@side) == 2
          blank_index = column.find_index(0)
          return blank_index*3 + row_number
        elsif diagonal_line.count(@side) == 2
          blank_index = diagonal_line.find_index(0)
          return 4 if blank_index == 1
          return 0 if blank_index == 0
          return 8 if blank_index == 2
        elsif counter_diagonal_line.count(@side) == 2
          blank_index = counter_diagonal_line.find_index(0)
          return 4 if blank_index == 1
          return 2 if blank_index == 0
          return 6 if blank_index == 2
        end
      end
    end
  end
end