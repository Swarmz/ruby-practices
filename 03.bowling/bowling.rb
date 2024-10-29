score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X' && shots.length < (2 * 9)
    shots.push(10, 0)
  elsif s == 'X' # 10フレーム目の場合 例：[10, 10, 10］
    shots << 10
  else
    shots << s.to_i
  end
end

frames = shots[0...18].each_slice(2).to_a # 0～9フレーム
frames << shots[18..]
frames.push([0, 0], [0, 0]) # each_consを10フレーム目まで継続させる

point = frames.each_cons(3).with_index.sum do |(frame, next_frame, next_next_frame), frame_num|
  frame.sum +
    if frame_num == 9 # 10フレーム目かどうかのチェック
      0
    elsif frame[0] == 10
      if next_frame[0] == 10
        if next_next_frame[0] == 10
          20
        elsif frame_num == 8 # 9フレーム目がdoubleの場合
          next_frame[0..1].sum
        else
          10 + next_next_frame[0]
        end
      else
        next_frame[0..1].sum
      end
    elsif frame[0..1].sum == 10
      next_frame[0]
    else
      0
    end
end

puts point
