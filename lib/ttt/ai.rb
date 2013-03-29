module TTT
  class AI
    attr_accessor :states
    def initialize(states=[0,0,0,0,0,0,0,0,0])
      @states = states
      @side = SIDE_X
    end

    def generate_next_move(states, side)
      @states = states
      states.index(0)+1
    end
  end
end