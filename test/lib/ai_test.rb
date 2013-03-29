require 'test_helper'

module TTT
  class TestAI < MiniTest::Unit::TestCase
    def setup
      @ai = AI.new
    end

    def test_always_pick_winning_position_first
      position = @ai.generate_next_move([SIDE_X,SIDE_X,0,SIDE_O,SIDE_O,0,0,0,0], SIDE_X)
      assert_equal(3, position)
      next_position = @ai.generate_next_move([SIDE_X,0,0,SIDE_X,SIDE_O,SIDE_O,0,0,0], SIDE_X)
      assert_equal(7, next_position)
    end

    def test_pick_last_empty_position
      @ai.states = [SIDE_O,SIDE_X,SIDE_O,SIDE_X,SIDE_X,SIDE_O,0,SIDE_O,SIDE_X]
      assert_equal(6, @ai.pick_last_position)
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

    def test_block_opponent
      @ai.states = [SIDE_O,SIDE_X,0,SIDE_X,SIDE_O,0,0,0,0]
      assert_equal(8, @ai.block_opponent)
    end

    def test_create_fork
      @ai.states = [SIDE_X,0,0,SIDE_O,0,0,SIDE_O,SIDE_O,SIDE_X]
      assert_equal(2, @ai.create_fork)
      @ai.states = [0,SIDE_X,0,0,SIDE_X,SIDE_O,0,SIDE_O,0]
      assert_equal(0, @ai.create_fork)
      @ai.states = [0,SIDE_O,SIDE_X,SIDE_X,0,0,0,0,SIDE_O]
      assert_equal(4, @ai.create_fork)
    end

    def test_block_fork
      @ai.states = [SIDE_O,0,0,SIDE_X,0,0,SIDE_X,SIDE_X,SIDE_O]
      assert_equal(2, @ai.block_fork)
      @ai.states = [0,SIDE_O,0,0,SIDE_O,SIDE_X,0,SIDE_X,0]
      assert_equal(0, @ai.block_fork)
      @ai.states = [0,SIDE_X,SIDE_O,SIDE_O,0,0,0,0,SIDE_X]
      assert_equal(4, @ai.block_fork)
    end

    def test_play_center
      @ai.states = [0,0,0,SIDE_X,0,0,0,0,SIDE_O]
      assert_equal(4, @ai.play_center)
      @ai.states = [0,0,0,SIDE_X,SIDE_O,0,0,0,SIDE_O]
      assert_equal(nil, @ai.play_center)
    end

    def test_play_opposite_corner
      @ai.states = [SIDE_O,0,0,0,0,0,0,0,0]
      assert_equal(8, @ai.play_opposite_corner)
    end

    def test_play_empty_corner
      @ai.states = [SIDE_O,0,0,0,0,SIDE_O,0,0,SIDE_X]
      assert_equal(2, @ai.play_empty_corner)
    end

    def test_play_empty_side
      @ai.states = [SIDE_O,0,0,0,0,SIDE_O,0,0,SIDE_X]
      assert_equal(1, @ai.play_empty_side)
    end

    def test_generate_next_move
      states = [SIDE_O,0,0,0,0,SIDE_O,0,0,SIDE_X]
      assert_kind_of(Integer, @ai.generate_next_move(states, SIDE_X))
    end
  end
end