#!/usr/bin/env ruby
require 'date'
require 'optparse'

parser = OptionParser.new
year = Date.today.year
month = Date.today.month

parser.on("-y [YYYY]", "Specificy a year") do |value|
  year = value.to_i
end
parser.on("-m [MM]", "Specificy a month") do |value|
  month = value.to_i
end
parser.parse!

puts "      #{month}月 #{year}"
puts "日 月 火 水 木 金 土"

def printStartingSpace(year, month)
    startingSpace = Date.new(year, month, 1).wday
    if startingSpace > 0 
      startingSpace.times do
        print "   "
      end
    end
end

def getDays(year, month)
    lastDay = Date.new(year, month, -1).day
    firstDay = Date.new(year, month, 1).day
    printDays(firstDay, lastDay, year, month)
end

def printDays(firstDay, lastDay, year, month)
  while firstDay <= lastDay
    if Date.new(year, month, firstDay).wday == 0 && firstDay != 1 #土曜日を表示した後に改行を入れる
      puts ""
    end
    print firstDay < 10 ? " #{firstDay} " : "#{firstDay} " #1桁と2桁の数字が同じ量のスペースを使用するために。
    firstDay += 1
  end
end

printStartingSpace(year, month)
getDays(year, month)



