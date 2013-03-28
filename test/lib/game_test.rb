require 'test_helper'

class TestGame < MiniTest::Unit::TestCase
  def setup
    @boardController = TTT::BoardController.new()
    @game = TTT::Game.new(@boardController)
  end

  def test_that_board_exists
    assert_equal @game.boardController, @boardController
  end

  def test_starts_the_game_with_pompt
    f = StringIO.new
    withIO(StringIO.new("x\n"), f) do
      out, err = capture_io do
        @game.start
      end
      assert_match(/Wanna play/, out)
      assert_match(/Which side/, out)
      assert_match(/You picked 'x'/, out)
      refute_match(/Invalid pick/, out)
    end
  end

  def test_starts_the_game_with_pompt_and_wrong_pick
    f = StringIO.new
    withIO(StringIO.new("H\no\n"), f) do
      out, err = capture_io do
        @game.start
      end
      assert_match(/Wanna play/, out)
      assert_match(/Which side/, out)
      assert_match(/Invalid pick/, out)
      assert_match(/You picked 'o'/, out)
    end
  end
end