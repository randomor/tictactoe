# encoding: utf-8
require_relative '../test_helper'

module TTT
  class TestBoard < MiniTest::Unit::TestCase
    def setup
      @board = Board.new
    end

    def test_assign_and_get_position
      assert_equal(0, @board[1])
      @board[1] = SIDE_X
      assert_equal(SIDE_X, @board[1])
      assert_equal([SIDE_X,0,0,0,0,0,0,0,0], @board.states)
    end

    def test_rows
      assert_equal([[0, 0, 0],[0, 0, 0],[0, 0, 0]], @board.rows)
      @board[2] = SIDE_O
      assert_equal([[0, SIDE_O, 0],[0, 0, 0],[0, 0, 0]], @board.rows)
    end

    def test_columns
      assert_equal([[0, 0, 0],[0, 0, 0],[0, 0, 0]], @board.columns)
      @board[3] = SIDE_X
      assert_equal([[0, 0, 0],[0, 0, 0],[SIDE_X, 0, 0]], @board.columns)
    end

    def test_diagonal_line
      assert_equal([0, 0, 0], @board.diagonal_line)
      @board[1], @board[5] = SIDE_O, SIDE_X
      assert_equal([SIDE_O, SIDE_X, 0], @board.diagonal_line)
    end

    def test_counter_diagonal_line
      assert_equal([0, 0, 0], @board.counter_diagonal_line)
      @board[7], @board[3] = SIDE_O, SIDE_X
      assert_equal([SIDE_X, 0, SIDE_O], @board.counter_diagonal_line)
    end

    def test_empty_position
      assert(@board.empty_position?(1))
      @board[3] = SIDE_X
      refute(@board.empty_position?(3))
    end

    def test_full
      refute(@board.full?)
      @other_board = Board.new([SIDE_X,SIDE_X,SIDE_O,SIDE_O,SIDE_O,SIDE_X,SIDE_O,SIDE_X,SIDE_O])
      assert(@other_board.full?)
    end

    def test_last_empty_position
      @other_board = Board.new([SIDE_X,SIDE_X,SIDE_O,SIDE_O,SIDE_O,SIDE_X,0,SIDE_X,SIDE_O])
      assert_equal(7, @other_board.last_empty_position)
    end
  end
end