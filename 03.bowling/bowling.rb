score = ARGV[0]
scores = score.split(',')
shots = []
FRAMES_ONE_TO_NINE = 9
SHOTS_PER_FRAME = 2
scores.each do |s|
  if s == 'X'
    (shots.length < FRAMES_ONE_TO_NINE * SHOTS_PER_FRAME ? shots.push(10, 0) : shots << 10)
  else
    shots << s.to_i
  end
end

frames = shots[...FRAMES_ONE_TO_NINE * SHOTS_PER_FRAME].each_slice(2).to_a
frames << shots[FRAMES_ONE_TO_NINE * SHOTS_PER_FRAME..]
frames.push([0, 0], [0, 0]) # each_consを10フレーム目まで継続させる
point = frames.each_cons(3).with_index(1).sum do |(frame, next_frame, next_next_frame), frame_num|
  frame.sum +
    if frame_num == 10
      0
    elsif frame[0] == 10
      if frame_num == 9 || next_frame[0] != 10 # 場合:(9目->[10, 0], [10, 例, 例]<-10目) -OR- フレーム1～8の場合「next_frame」はストライクではない
        next_frame[0..1].sum
      else
        10 + next_next_frame[0]
      end
    elsif frame[0..1].sum == 10
      next_frame[0]
    else
      0
    end
end

puts point
