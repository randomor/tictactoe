require_relative '../test_helper'

class TTT::TestGame < MiniTest::Unit::TestCase
  def setup
    @game = TTT::Game.new
  end

  def test_starts_the_game_with_pompt
    f = StringIO.new
    withIO(StringIO.new("x\nexit\n"), f) do
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
    withIO(StringIO.new("H\no\nexit\n"), f) do
      out, err = capture_io do
        @game.start
      end
      assert_match(/Wanna play/, out)
      assert_match(/Which side/, out)
      assert_match(/Invalid pick/, out)
      assert_match(/You picked 'o'/, out)
    end
  end

  def test_pick_side_and_wrong_move
    f = StringIO.new
    withIO(StringIO.new("o\nd\n3\nexit\n"), f) do
      out, err = capture_io do
        @game.start
      end
      assert_match(/You picked 'o'/, out)
      assert_match(/next move?/, out)
      assert_match(/not a valid move! Please try again/, out)
    end
  end

  def test_computer_move_after_user
    f = StringIO.new
    withIO(StringIO.new("o\nexit\n"), f) do
      out, err = capture_io do
        @game.start
      end
      assert_match(/Wanna play/, out)
      assert_match(/Which side/, out)
      assert_match(/You picked 'o'/, out)
      assert_match(/Computer moved/, out)
    end
  end

end