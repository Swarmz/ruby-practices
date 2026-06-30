# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot) if second_shot
    @third_shot = Shot.new(third_shot) if third_shot
  end

  def score
    if strike?
      return 10 + @second_shot.score + @third_shot.score
    elsif spare?
      return 10 + @third_shot.score
    end

    @first_shot.score + @second_shot.score
  end

  private

  def spare?
    @first_shot.score + @second_shot.score == 10
  end

  def strike?
    @first_shot.score == 10
  end
end
