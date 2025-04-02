#!/usr/bin/env ruby
require 'date'
require 'optparse'

def main
  year, month = get_year_month
  puts "#{month}月 #{year}".center(20)
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
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)
  print "   " * first_date.wday  
  first_date.upto(last_date) do |date|
    print "\n" if date.sunday? && date.day != 1 # 土曜日を表示した後に改行を入れる
    print date.day.to_s.rjust(2) + " "
  end
end

main
