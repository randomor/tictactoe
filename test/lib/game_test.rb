# encoding: utf-8
require_relative '../test_helper'

module TTT
  class TestGame < MiniTest::Unit::TestCase
    def setup
      @game = TTT::Game.new
    end

    def test_get_side_from_user
      f = StringIO.new
      withIO(StringIO.new("x\n"), f) do
        out, err = capture_io do
          @game.get_side_from_user
        end
        assert_match(/You picked 'x'/, out)
        assert_match(SIDE_X, @game.user_side)
        assert_match(SIDE_X, @game.current_player)
      end

      f = StringIO.new
      withIO(StringIO.new("d\nf\no\n"), f) do
        out, err = capture_io do
          @game.get_side_from_user
        end
        assert_equal(2, out.scan(/Invalid pick, pick again please./).count)
        assert_match(/You picked 'o'/, out)
        assert_match(SIDE_O, @game.user_side)
        assert_match(SIDE_X, @game.current_player)
      end
    end

    def test_ask_user_for_next_move
      f = StringIO.new
      withIO(StringIO.new("3\n"), f) do
        out, err = capture_io do
          assert_equal(3, @game.ask_user_for_next_move)
        end
        assert_match(/What's your next move/, out)
      end
    end

    def test_ask_user_for_next_move_until_move_valid
      f = StringIO.new
      @game.board_controller.next_move(3)
      withIO(StringIO.new("3\n10\n3\ndou\n6\n"), f) do
        out, err = capture_io do
          assert_equal(6, @game.ask_user_for_next_move)
        end
        assert_equal(4, out.scan(/try again/).count)
      end
    end

    def test_start_prompt
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

    def test_pick_side_and_multiple_wrong_move
      f = StringIO.new
      withIO(StringIO.new("o\nd\nx\n3\n3\nexit\n"), f) do
        out, err = capture_io do
          @game.start
        end
        assert_match(/You picked 'o'/, out)
        assert_match(/next move?/, out)
        assert_equal(3, out.scan(/not a valid move! Please try again/).count)
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

    def test_replay_game
      f = StringIO.new
      withIO(StringIO.new("o\ny\no\nexit\n"), f) do
        out, err = capture_io do
          @game.replay_game
        end
        assert_match(/a reply/, out)
        assert_match(/could not understand/, out)
        assert_match(/Which side/, out)
        assert_match(/You picked 'o'/, out)
        assert_match(/Computer moved/, out)
        refute_match(1, out.scan(/Your turn/).count)
      end
    end

    def test_replay_game_after_selecting_side_x
      f = StringIO.new
      withIO(StringIO.new("x\n"), f) do
        out, err = capture_io do
          @game.get_side_from_user
        end
        assert_match(/You picked 'x'/, out)
        assert_match(SIDE_X, @game.user_side)
        assert_match(SIDE_X, @game.current_player)
      end
      withIO(StringIO.new("o\ny\no\nexit\n"), f) do
        out, err = capture_io do
          @game.replay_game
        end
        assert_match(/a reply/, out)
        assert_match(/could not understand/, out)
        assert_match(/Which side/, out)
        assert_match(/You picked 'o'/, out)
        assert_match(/Computer moved/, out)
        refute_match(1, out.scan(/Your turn/).count)
        assert_equal(SIDE_O, @game.user_side)
      end
    end

    def test_game_result_to_user
      assert_match(SIDE_X, @game.user_side)
      assert_match(/Still Playing/, @game.game_result_to_user(:Playing))
      assert_match(/won/, @game.game_result_to_user(:X_won))
      assert_match(/lose/, @game.game_result_to_user(:O_won))
      assert_match(/tie/, @game.game_result_to_user(:Tie))

      f = StringIO.new
      withIO(StringIO.new("o\n"), f) do
        out, err = capture_io do
          @game.get_side_from_user
        end
        assert_match(/You picked 'o'/, out)
      end
      assert_match(SIDE_O, @game.user_side)
      assert_match(/lose/, @game.game_result_to_user(:X_won))
      assert_match(/won/, @game.game_result_to_user(:O_won))
      assert_match(/tie/, @game.game_result_to_user(:Tie))
    end
  end
end