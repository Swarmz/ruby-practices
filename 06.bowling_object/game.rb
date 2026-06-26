# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(score_sheet)
    @frames = parse_score_sheet(score_sheet)
  end

  def parse_score_sheet(score_sheet)
    shots = score_sheet.split(',')
    frames = []
    shot_index = 0

    while frames.size < 10
      frames << Frame.new(shots[shot_index], shots[shot_index + 1], shots[shot_index + 2])
      shot_index += (shots[shot_index] == 'X' ? 1 : 2)
    end

    frames
  end

  def calculate_total_score
    total = 0

    @frames.each do |frame|
      total += frame.score
    end

    total
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(ARGV[0])
  puts game.calculate_total_score
end
