#!/usr/bin/env ruby
require 'date'
require 'optparse'

def main
  year, month = get_year_month
  puts "#{month}月 #{year}".rjust(8 + month.digits.length + year.digits.length)
  puts "日 月 火 水 木 金 土"
  print_cal(year, month)
end

def get_year_month
  year = Date.today.year
  month = Date.today.month
  if ARGV.any?
    opt = OptionParser.new
    opt.on("-y [YYYY]", "Specify a year") {|value| year = value.to_i}
    opt.on("-m [MM]", "Specify a month") {|value| month = value.to_i}
    opt.parse!
  end
  [year, month]
end

def print_cal(year, month)
  first_day = Date.new(year, month, 1)
  last_day = Date.new(year, month, -1)
  print "".rjust(first_day.wday * 3) 
  (first_day..last_day).each do |date|
    print "\n" if date.sunday? && date.day != 1 # 土曜日を表示した後に改行を入れる
    print "#{date.day}".center(3)
  end
end

main
