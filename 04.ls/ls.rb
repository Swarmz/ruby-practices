# frozen_string_literal: true

require 'optparse'
require 'debug'

COLUMNS = 3

def main
  files = if ARGV.empty?
            Dir.new(Dir.pwd).each_child.filter_map { |file| file unless file.start_with?('.') }
          else
            handle_args(files)
          end
  arranged_files = arrange_files(files)
  print_files(arranged_files)
end

def handle_args(files)
  parser = OptionParser.new
  parser.on('-a', '--all', 'Show all files, including those that start with .') do
    files = Dir.new(Dir.pwd).sort
  end
  parser.on('-r', '--reverse', 'Show files in reverse order') do
    files = files.sort.reverse
  end
  begin
    parser.parse!
  rescue OptionParser::InvalidOption => e
    puts e
    puts "Try 'ruby ls.rb --help' for more information."
    exit
  end
  files
end

def arrange_files(files)
  rows = files.count.ceildiv(COLUMNS)
  # transpose メソッドを使用するには、行と列を入れ替えることができるように、1-2個の数字しか持たない配列を空白で埋める
  split_files = files.each_slice(rows).to_a.tap { |array| array.last.fill(' ', array.last.length, rows - array.last.length) }
  split_and_spaced_files = split_files.map do |row|
    max_char_length = row.max_by(&:length).length
    row.map do |file_name|
      file_name.ljust(max_char_length + 2)
    end
  end
  split_and_spaced_files.transpose
end

def print_files(files)
  files.each do |row|
    row.each do |file_name|
      print file_name
    end
    print "\n"
  end
end

main
