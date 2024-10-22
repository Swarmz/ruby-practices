# frozen_string_literal: true

require 'debug'
score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X' && shots.length < 18
    shots << 10
    shots << 0
  elsif s == 'X' # 10フレーム目の場合 例：[10, 10, 10］
    shots << 10
  else
    shots << s.to_i
  end
end

frames = []
shots[0..17].each_slice(2) do |s| # 0～9フレーム
  frames << s
end
shots[18..].each_slice(3) do |s| # 10フレーム目は3桁
  frames << s
end
frames.push([0, 0], [0, 0]) # each_consを10フレーム目まで継続させる

point = 0

frames.each_cons(3) do |frame1, frame2, frame3|
  point += if frame1.equal? frames[-3] # 10フレーム目かどうかのチェック
             frame1.sum
           elsif frame1[0] + frame2[0] + frame3[0] == 30 # ターキー
             30
           elsif frame1[0] + frame2[0] == 20 # ダブル
             if frame2.equal? frames[-3] # 9フレーム目がdoubleの場合
               10 + frame2[0] + frame2[1]
             else # 通常のdoubleの場合
               20 + frame3[0]
             end
           elsif frame1[0] == 10 # ストライク
             10 + frame2[0] + frame2[1]
           elsif frame1[0] + frame1[1] == 10 # スペア
             frame1.sum + frame2[0]
           else
             frame1.sum
           end
end

puts point
