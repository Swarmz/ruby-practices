# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot) if second_shot
    @third_shot = Shot.new(third_shot) if third_shot
  end

  def score
    if strike? || spare?
      [@first_shot, @second_shot, @third_shot].sum(&:score)
    else
      pin_count
    end
  end

  private

  def pin_count
    @first_shot.score + @second_shot.score
  end

  def spare?
    pin_count == 10 && !strike?
  end

  def strike?
    @first_shot.score == 10
  end
end
