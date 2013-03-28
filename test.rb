require "rubygems"
require "minitest/autorun"
require "stringio"


module TTT
  class Game
    attr_reader :board, :side

    def initialize(board=Board.new)
      @board  = board
      @side   = "x"
    end

    def start
      start_prompt
      get_side_from_user
      display_board
    end

    def get_side_from_user
      puts 'Which side would you pick? Type in "x" or "o".'
      input = $stdin.gets.chomp.downcase
      if input.length == 1 && ['o', 'x'].include?(input)
        @side = input
        puts "You picked '#{@side}'"
      else
        puts 'Invalid pick, pick again please.'
        get_side_from_user
      end
    end

    def start_prompt
      $stdout.puts <<-PROMPT
        | Wanna play Tic-Tac-Toe?
        | Align "x" or "o" to horizontal, vertical or diagonal lines in 3 to win.
        | "X" always go first.
      PROMPT
    end
  end

  class Board
  end
end

class TestGame < MiniTest::Unit::TestCase
  def setup
    @board = TTT::Board.new()
    @game = TTT::Game.new(@board)
  end

  def test_that_board_exists
    assert_equal @game.board, @board
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

  def test_that_will_be_skipped
    skip "test this later"
  end

  def withIO(newin, newout)
    old_STDIN = $stdin
    old_STDOUT = $stdout
    $stdin = newin
    $stdout = newout
    yield old_STDIN, old_STDOUT
    ensure
    $stdin = old_STDIN
    $stdout = old_STDOUT
  end
end

class TestBoard < MiniTest::Unit::TestCase
  def setup
    @board = TTT::Board.new()
  end

  def test_that_board_exists
    assert @board.display
  end


end