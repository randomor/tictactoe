require_relative '../test_helper'

module TTT
  class TestBoardController < MiniTest::Unit::TestCase
    def setup
      @board_controller = BoardController.new()
    end

    def test_board_draws
      assert_respond_to(@board_controller, :board)
      assert_equal(@board_controller.current_mover, SIDE_X)
      assert_equal(@board_controller.game_status, :Playing)
    end

    def test_draws_well
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
      assert_match(board, @board_controller.board)
    end

    def test_next_move
      @board_controller.next_move(3)
      board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | 2 | x ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
      assert_match(board, @board_controller.board)
    end

    def test_next_invalid_move
      board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | 2 | x ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
      assert_raises(Errors::InvalidMoveError) do
        @board_controller.next_move(3)
        @board_controller.next_move(3)
      end
      assert_equal(SIDE_O, @board_controller.current_mover)
      assert_match(board, @board_controller.board)
      assert_equal(@board_controller.game_status, :Playing)
    end

    def test_next_computer_move
      start_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | x | 3 ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
      @board_controller.next_move(2)
      assert_match(start_board, @board_controller.board)
      end_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | x | 3 ¦
        ¦——— ——— ———¦
        ¦ 4 | o | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
      @board_controller.next_computer_move
      assert_match(end_board, @board_controller.board)
    end

    def test_changes_right_status_when_x_won
      start_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | x | 3 ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
      @board_controller.next_move(2)
      assert_match(start_board, @board_controller.board)
      @board_controller.next_move(1)
      @board_controller.next_move(5)
      @board_controller.next_move(4)
      assert_match(/Playing/, @board_controller.game_status)
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
      assert_match(end_board, @board_controller.board)
      assert_match("You won", @board_controller.game_status)
    end

    def test_changes_right_status_when_o_won
      start_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | x | 3 ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
      @board_controller.next_move(2)
      assert_match(start_board, @board_controller.board)
      @board_controller.next_move(1)
      @board_controller.next_move(5)
      @board_controller.next_move(3)
      assert_match(/Playing/, @board_controller.game_status)
      @board_controller.next_move(8)
      end_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ o | x | o ¦
        ¦——— ——— ———¦
        ¦ 4 | x | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | x | 9 ¦
        ¦===========¦
      board
      assert_match(end_board, @board_controller.board)
      assert_match("You won", @board_controller.game_status)
    end

    def test_changes_right_status_when_x_lose
      start_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | 2 | 3 ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | x ¦
        ¦===========¦
      board
      @board_controller.next_move(9)
      assert_match(start_board, @board_controller.board)
      @board_controller.next_move(1)
      @board_controller.next_move(4)
      @board_controller.next_move(2)
      assert_match(/Playing/, @board_controller.game_status)
      @board_controller.next_move(8)
      @board_controller.next_move(3)
      end_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ o | o | o ¦
        ¦——— ——— ———¦
        ¦ x | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | x | x ¦
        ¦===========¦
      board
      assert_match(end_board, @board_controller.board)
      assert_match("You lose", @board_controller.game_status)
    end

    def test_changes_right_status_when_tie
      start_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | 2 | 3 ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | x ¦
        ¦===========¦
      board
      @board_controller.next_move(9)
      assert_match(start_board, @board_controller.board)
      @board_controller.next_move(1)
      @board_controller.next_move(4)
      @board_controller.next_move(5)
      assert_match(/Playing/, @board_controller.game_status)
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
      assert_match(end_board, @board_controller.board)
      assert_match("tie", @board_controller.game_status)
    end

    def test_detects_diagonal_winning_status
      start_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ x | 2 | 3 ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
      @board_controller.next_move(1)
      assert_match(start_board, @board_controller.board)
      @board_controller.next_move(5)
      @board_controller.next_move(2)
      @board_controller.next_move(3)
      assert_match(/Playing/, @board_controller.game_status)
      @board_controller.next_move(6)
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
      assert_match(end_board, @board_controller.board)
      assert_match("lose", @board_controller.game_status)
    end

    def test_detects_counter_diagonal_winning_status
      start_board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ x | 2 | 3 ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
      @board_controller.next_move(1)
      assert_match(start_board, @board_controller.board)
      @board_controller.next_move(2)
      @board_controller.next_move(5)
      @board_controller.next_move(6)
      assert_match(/Playing/, @board_controller.game_status)
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
      assert_match(end_board, @board_controller.board)
      assert_match("won", @board_controller.game_status)
    end
  end
end