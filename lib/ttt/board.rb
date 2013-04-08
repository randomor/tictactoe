module TTT
  class Board
    attr_reader :states

    def initialize(states = [0,0,0,0,0,0,0,0,0])
      @states = states
    end

    def []=(position, value)
      index = position - 1
      @states[index] = value
    end

    def [](position)
      index = position - 1
      @states[index]
    end

    def rows
      @states.each_slice(3).to_a
    end

    def columns
      rows.transpose
    end

    def diagonal_line
      [self[1], self[5], self[9]]
    end

    def counter_diagonal_line
      [self[3], self[5], self[7]]
    end

    def empty_position?(position)
      self[position] == 0
    end

    def full?
      @states.count(0) == 0
    end

    def last_empty_position
      return @states.find_index(0) + 1 if @states.count(0) == 1
    end

    def winning_position_for_side(side)
      horizontal_winning_position_for_side(side) || vertical_winning_position_for_side(side) || diagonal_line_winning_position_for_side(side) || counter_diagonal_line_winning_position_for_side(side)
    end

    def counter_diagonal_line_winning_position_for_side(side)
      if counter_diagonal_line.count(side) == 2 && counter_diagonal_line.count(0) == 1
        blank_index = counter_diagonal_line.find_index(0)
        return blank_index * 3 + (3 - blank_index)
        # return 3 if blank_index == 0
        # return 5 if blank_index == 1
        # return 7 if blank_index == 2
      end
      return nil
    end

    def diagonal_line_winning_position_for_side(side)
      if diagonal_line.count(side) == 2 && diagonal_line.count(0) == 1
        blank_index = diagonal_line.find_index(0)
        return blank_index * 3 + blank_index + 1
        # return 1 if blank_index == 0
        # return 5 if blank_index == 1
        # return 9 if blank_index == 2
      end
      return nil
    end

    def vertical_winning_position_for_side(side)
      columns.each_with_index do |current_column, column_number|
        if current_column.count(side) == 2 && current_column.count(0) == 1
          return column_number + current_column.find_index(0) * 3 + 1
        end
      end
      return nil
    end

    def horizontal_winning_position_for_side(side)
      rows.each_with_index do |current_row, row_number|
        if current_row.count(side) == 2 && current_row.count(0) == 1
          return row_number*3 + current_row.find_index(0) + 1
        end
      end
      return nil
    end

    def forking_position_for_side(side)
      #don't play corner for these moves.
      if @states == [SIDE_X,0,0,0,SIDE_O,0,0,0,SIDE_X] || @states == [SIDE_O,0,0,0,SIDE_O,0,0,0,SIDE_O] || @states ==  [0,0,SIDE_X,0,SIDE_O,0,SIDE_X,0,0] || @states == [0,0,SIDE_O,0,SIDE_X,0,SIDE_O,0,0]
        return [2, 4, 6, 8].sample 
      end
      rows.each_with_index do |current_row, row_number|
        current_row.each_with_index do |state, column_number|
          next if state != 0
          current_column = columns[column_number]
          counter = 0
          counter+=1 if current_column.count(side) == 1 && current_column.count(0) == 2
          counter+=1 if current_row.count(side) == 1 && current_row.count(0) == 2
          counter+=1 if ([[1, 1], [0, 0], [2, 2]].include? [row_number, column_number]) && diagonal_line.count(side) == 1 && diagonal_line.count(0) == 2
          counter+=1 if ([[1, 1], [0, 2], [2, 0]].include? [row_number, column_number]) && counter_diagonal_line.count(side) == 1 && counter_diagonal_line.count(0) == 2
          return row_number*3 + column_number + 1 if counter >= 2
        end
      end
      return nil
    end
  end
end