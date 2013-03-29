require 'test_helper'

module TTT
  class TestAI < MiniTest::Unit::TestCase
    def setup
      @ai = AI.new
    end

    def test_always_pick_winning_position_first
      position = @ai.generate_next_move([SIDE_X,SIDE_X,0,SIDE_O,SIDE_O,0,0,0,0], SIDE_X)
      assert_equal(3, position)
    end

  end
end