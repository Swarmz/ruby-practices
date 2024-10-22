#!/usr/bin/env ruby
require 'date'
require 'optparse'
require 'debug'

def main
  year = Date.today.year
  month = Date.today.month
  if ARGV.any?
    opt = OptionParser.new
    opt.on("-y [YYYY]", "Specify a year") {|value| year = value.to_i}
    opt.on("-m [MM]", "Specify a month") {|value| month = value.to_i}
    opt.parse!
  end
  puts "      #{month}月 #{year}"
  puts "日 月 火 水 木 金 土"
  print_cal(year, month)
end

def print_cal(year, month)
  first_day = Date.new(year, month, 1)
  last_day = Date.new(year, month, -1)
  print " ".rjust(first_day.wday*3) # 一行目のpadding
  (first_day..last_day).each do |date|
    puts "" if date.sunday? && date.day != 1 # 土曜日を表示した後に改行を入れる
    print date.day < 10 ? "#{date.day}".ljust(3) : "#{date.day}".ljust(3) 
  end
end

main
