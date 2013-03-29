require 'test_helper'

module TTT
  class TestAI < MiniTest::Unit::TestCase
    def setup
      @ai = AI.new
    end

    def test_always_pick_winning_position_first
      skip
      position = @ai.generate_next_move([SIDE_X,SIDE_X,0,SIDE_O,SIDE_O,0,0,0,0], SIDE_X)
      assert_equal(3, position)
      next_position = @ai.generate_next_move([SIDE_X,0,0,SIDE_X,SIDE_O,SIDE_O,0,0,0], SIDE_X)
      assert_equal(7, next_position)
    end

    def test_pick_last_empty_position
      @ai.states = [SIDE_O,SIDE_X,SIDE_O,SIDE_X,SIDE_X,SIDE_O,0,SIDE_O,SIDE_X]
      assert_equal(6, @ai.pick_winning_index)
    end

    def test_pick_horizontal_winning_position
      @ai.states = [SIDE_X,SIDE_X,0,SIDE_O,SIDE_O,0,0,0,0]
      assert_equal(2, @ai.pick_winning_index)
    end

    def test_pick_vertical_winning_position
      @ai.states = [SIDE_X,0,0,SIDE_X,SIDE_O,SIDE_O,0,0,0]
      assert_equal(6, @ai.pick_winning_index)
    end

    def test_pick_diagnoal_winning_position
      @ai.states = [SIDE_X,SIDE_O,SIDE_O,SIDE_O,0,SIDE_X,0,SIDE_O,SIDE_X]
      assert_equal(4, @ai.pick_winning_index)
    end

    def test_pick_counter_diagnoal_winning_position
      @ai.states = [0,0,SIDE_X,SIDE_O,SIDE_X,0,0,SIDE_O,SIDE_O]
      assert_equal(6, @ai.pick_winning_index)
    end

  end
end