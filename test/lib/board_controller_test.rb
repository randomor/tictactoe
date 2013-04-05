# encoding: utf-8

require_relative '../test_helper'

module TTT
  class TestBoardController < MiniTest::Unit::TestCase
    def setup
      @board_controller = BoardController.new
    end

    def test_controller_properties
      assert_respond_to(@board_controller, :render_view)
      assert_equal(@board_controller.current_mover, SIDE_X)
      assert_equal(@board_controller.game_status, :Playing)
    end

    def test_valid_move
      assert_equal(true, @board_controller.valid_move?(3))
      board = Board.new [0,SIDE_X,0,0,0,0,0,0,0]
      other_board_controller = BoardController.new(board)
      assert_equal(false, other_board_controller.valid_move?(2))
    end

    def test_board_render
      #heredoc indent
      #http://rubyquicktips.com/post/4438542511/heredoc-and-indent
      board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | 2 | 3 ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
      assert_match(board, @board_controller.render_view)

      other_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | x | 3 ¦
        ¦——— ——— ———¦
        ¦ o | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
      board = Board.new [0,SIDE_X,0,SIDE_O,0,0,0,0,0]
      other_board_controller = BoardController.new(board)
      assert_match(other_board, other_board_controller.render_view)
    end

    def test_next_move_switch_current_mover
      assert_match(SIDE_X, @board_controller.current_mover)
      @board_controller.next_move(3)
      assert_match(SIDE_O, @board_controller.current_mover)
    end

    def test_next_invalid_move_not_switch_current_mover
      @board_controller.next_move(3)
      assert_equal(SIDE_O, @board_controller.current_mover)
      assert_raises(Errors::InvalidMoveError) do
        @board_controller.next_move(3)
      end
      assert_equal(SIDE_O, @board_controller.current_mover)
    end


    def test_changes_right_status_when_x_won
      @board_controller.next_move(2)
      @board_controller.next_move(1)
      @board_controller.next_move(5)
      @board_controller.next_move(4)
      assert_equal(:Playing, @board_controller.game_status)
      @board_controller.next_move(8)
      end_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ o | x | 3 ¦
        ¦——— ——— ———¦
        ¦ o | x | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | x | 9 ¦
        ¦===========¦
      board
      assert_match(end_board, @board_controller.render_view)
      assert_equal(:X_won, @board_controller.game_status)
    end

    def test_changes_right_status_when_o_won
      @board_controller.next_move(9)
      @board_controller.next_move(1)
      @board_controller.next_move(5)
      @board_controller.next_move(3)
      assert_equal(:Playing, @board_controller.game_status)
      @board_controller.next_move(8)
      @board_controller.next_move(2)
      end_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ o | o | o ¦
        ¦——— ——— ———¦
        ¦ 4 | x | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | x | x ¦
        ¦===========¦
      board
      assert_match(end_board, @board_controller.render_view)
      assert_equal(:O_won, @board_controller.game_status)
    end

    def test_changes_right_status_when_tie
      @board_controller.next_move(9)
      @board_controller.next_move(1)
      @board_controller.next_move(4)
      @board_controller.next_move(5)
      assert_equal(:Playing, @board_controller.game_status)
      @board_controller.next_move(8)
      @board_controller.next_move(6)
      @board_controller.next_move(2)
      @board_controller.next_move(7)
      @board_controller.next_move(3)
      end_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ o | x | x ¦
        ¦——— ——— ———¦
        ¦ x | o | o ¦
        ¦––– ––– –––¦
        ¦ o | x | x ¦
        ¦===========¦
      board
      assert_match(end_board, @board_controller.render_view)
      assert_equal(:Tie, @board_controller.game_status)
    end

    def test_detects_diagonal_winning_status
      @board_controller.next_move(1)
      @board_controller.next_move(5)
      @board_controller.next_move(2)
      @board_controller.next_move(3)
      @board_controller.next_move(6)
      assert_equal(:Playing, @board_controller.game_status)
      @board_controller.next_move(7)
      end_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ x | x | o ¦
        ¦——— ——— ———¦
        ¦ 4 | o | x ¦
        ¦––– ––– –––¦
        ¦ o | 8 | 9 ¦
        ¦===========¦
      board
      assert_match(end_board, @board_controller.render_view)
      assert_equal(:O_won, @board_controller.game_status)
    end

    def test_detects_counter_diagonal_winning_status
      @board_controller.next_move(1)
      @board_controller.next_move(2)
      @board_controller.next_move(5)
      @board_controller.next_move(6)
      assert_equal(:Playing, @board_controller.game_status)
      @board_controller.next_move(9)
      end_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ x | o | 3 ¦
        ¦——— ——— ———¦
        ¦ 4 | x | o ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | x ¦
        ¦===========¦
      board
      assert_match(end_board, @board_controller.render_view)
      assert_equal(:X_won, @board_controller.game_status)
    end
  end
end