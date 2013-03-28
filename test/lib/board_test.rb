require 'test_helper'
module TTT
  class TestBoardController < MiniTest::Unit::TestCase
    def setup
      @boardController = BoardController.new()
    end

    def test_board_draws
      assert_respond_to(@boardController, :board)
      assert_equal(@boardController.current_mover, SIDE_X)
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
      assert_match(board, @boardController.board)
    end

    def test_next_move
      @boardController.next_move(3)
      board = <<-board.gsub(/^\s+/, '')
        ┌===========┐
        ¦ 1 | 2 | x ¦
        ¦——— ——— ———¦
        ¦ 4 | 5 | 6 ¦
        ¦––– ––– –––¦
        ¦ 7 | 8 | 9 ¦
        ¦===========¦
      board
      assert_match(board, @boardController.board)
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
        @boardController.next_move(3)
        @boardController.next_move(3)
      end
      assert_equal(SIDE_O, @boardController.current_mover)
      assert_match(board, @boardController.board)
    end
  end
end