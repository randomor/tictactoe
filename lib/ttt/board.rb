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
  end
end