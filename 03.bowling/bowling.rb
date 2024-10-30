score = ARGV[0]
scores = score.split(',')
shots = []
frames_one_to_nine = 9 * 2
scores.each do |s|
  if s == 'X' && shots.length < frames_one_to_nine
    shots.push(10, 0)
  elsif s == 'X' # 10フレーム目の場合 例：[10, 10, 10］
    shots << 10
  else
    shots << s.to_i
  end
end

frames = shots[...frames_one_to_nine].each_slice(2).to_a
frames << shots[frames_one_to_nine..]
frames.push([0, 0], [0, 0]) # each_consを10フレーム目まで継続させる

point = frames.each_cons(3).with_index(1).sum do |(frame, next_frame, next_next_frame), frame_num|
  frame.sum +
    if frame_num == 10
      0
    elsif frame[0] == 10
      if frame_num == 9 || next_frame[0] != 10 # 9フレーム目がダブルの場合のため ||
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
