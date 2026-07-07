# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'shot'
require_relative 'frame'
require_relative 'game'

class BowlingTest < Minitest::Test
  def test_shot_strike_equals_ten
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end

  def test_frame_score
    frame = Frame.new('2', '4', '1')
    assert_equal 6, frame.score
  end

  def test_frame_score_when_strike
    frame = Frame.new('X', '7', '1')
    assert_equal 18, frame.score
  end

  def test_frame_score_when_spare
    frame = Frame.new('3', '7', '1')
    assert_equal 11, frame.score
  end

  def test_game_calculate_score
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, game.calculate_total_score
  end

  def test_game_all_zero
    game = Game.new('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
    assert_equal 0, game.calculate_total_score
  end

  def test_game_all_strikes
    game = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal 300, game.calculate_total_score
  end
end
