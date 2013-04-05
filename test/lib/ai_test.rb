# encoding: utf-8
require_relative '../test_helper'

module TTT
  class TestAI < MiniTest::Unit::TestCase
    def setup
      @ai = AI.new
    end

    def test_always_pick_winning_position
      board = Board.new([SIDE_X,SIDE_X,0,SIDE_O,SIDE_O,0,0,0,0])
      position = @ai.generate_next_move(board, SIDE_X)
      assert_equal(3, position)
      other_board = Board.new([SIDE_X,0,0,SIDE_X,SIDE_O,SIDE_O,0,0,0])
      next_position = @ai.generate_next_move(other_board, SIDE_X)
      assert_equal(7, next_position)
      third_board = Board.new([SIDE_X,0,0,SIDE_X,SIDE_O,0,0,0,0])
      next_position = @ai.generate_next_move(third_board, SIDE_O)
      assert_equal(7, next_position)
    end

    def test_pick_last_empty_position
      @ai.board = Board.new([SIDE_O,SIDE_X,SIDE_O,SIDE_X,SIDE_X,SIDE_O,0,SIDE_O,SIDE_X])
      assert_equal(7, @ai.pick_last_position)
    end

    def test_pick_horizontal_winning_position
      @ai.board = Board.new([SIDE_X,SIDE_X,0,SIDE_O,SIDE_O,0,0,0,0])
      assert_equal(3, @ai.pick_winning_position)
    end

    def test_pick_vertical_winning_position
      @ai.board = Board.new [SIDE_X,0,0,SIDE_X,SIDE_O,SIDE_O,0,0,0]
      assert_equal(7, @ai.pick_winning_position)
      @ai.board = Board.new [SIDE_X, SIDE_O, SIDE_X, 0, SIDE_O, SIDE_X, 0, 0, 0]
      @ai.side = SIDE_O
      assert_equal(8, @ai.pick_winning_position)
    end

    def test_pick_diagnoal_winning_position
      @ai.board = Board.new [SIDE_X,SIDE_O,SIDE_O,SIDE_O,0,SIDE_X,0,SIDE_O,SIDE_X]
      assert_equal(5, @ai.pick_winning_position)
    end

    def test_pick_counter_diagnoal_winning_position
      @ai.board = Board.new [0,0,SIDE_X,SIDE_O,SIDE_X,0,0,SIDE_O,SIDE_O]
      assert_equal(7, @ai.pick_winning_position)
    end

    def test_block_opponent
      @ai.board = Board.new [SIDE_O,SIDE_X,0,SIDE_X,SIDE_O,0,0,0,0]
      assert_equal(9, @ai.block_opponent)
      @ai.board = Board.new [SIDE_X,0,0,SIDE_X,SIDE_O,0,0,0,0]
      @ai.side = SIDE_O
      assert_equal(7, @ai.block_opponent)
    end

    def test_create_fork
      @ai.board = Board.new [SIDE_X,0,0,SIDE_O,0,0,SIDE_O,SIDE_O,SIDE_X]
      assert_equal(3, @ai.create_fork)
      @ai.board = Board.new [0,SIDE_X,0,0,SIDE_X,SIDE_O,0,SIDE_O,0]
      assert_equal(1, @ai.create_fork)
      @ai.board = Board.new [0,SIDE_O,SIDE_X,SIDE_X,0,0,0,0,SIDE_O]
      assert_equal(5, @ai.create_fork)
    end

    def test_do_not_play_in_corner_fork
      @ai.board = Board.new [SIDE_X,0,0,0,SIDE_O,0,0,0,SIDE_X]
      assert_includes([2, 4, 6, 8], @ai.create_fork)
    end

    def test_block_fork
      @ai.board = Board.new [SIDE_O,0,0,SIDE_X,0,0,SIDE_X,SIDE_X,SIDE_O]
      assert_equal(3, @ai.block_fork)
      @ai.board = Board.new [0,SIDE_O,0,0,SIDE_O,SIDE_X,0,SIDE_X,0]
      assert_equal(1, @ai.block_fork)
      @ai.board = Board.new [0,SIDE_X,SIDE_O,SIDE_O,0,0,0,0,SIDE_X]
      assert_equal(5, @ai.block_fork)
    end

    def test_play_center
      @ai.board = Board.new [0,0,0,SIDE_X,0,0,0,0,SIDE_O]
      assert_equal(5, @ai.play_center)
      @ai.board = Board.new [0,0,0,SIDE_X,SIDE_O,0,0,0,SIDE_O]
      assert_equal(nil, @ai.play_center)
    end

    def test_play_opposite_corner
      @ai.board = Board.new [SIDE_O,0,0,0,0,0,0,0,0]
      assert_equal(9, @ai.play_opposite_corner)
    end

    def test_play_empty_corner
      @ai.board = Board.new [SIDE_O,0,0,0,0,SIDE_O,0,0,SIDE_X]
      assert_equal(3, @ai.play_empty_corner)
    end

    def test_play_empty_side
      @ai.board = Board.new [SIDE_O,0,0,0,0,SIDE_O,0,0,SIDE_X]
      assert_equal(2, @ai.play_empty_side)
    end

    def test_generate_next_move
      board = Board.new [SIDE_O,0,0,0,0,SIDE_O,0,0,SIDE_X]
      assert_kind_of(Integer, @ai.generate_next_move(board, SIDE_X))
    end
  end
end