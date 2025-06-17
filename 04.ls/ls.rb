# frozen_string_literal: true

require 'optparse'
require 'etc'

FILES = Dir.glob('*')
COLUMNS = 3
PERMISSION_LEVELS = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze
FILE_TYPES = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket' => 's'
}.freeze

def main
  options = create_options
  files = customize_file_list(FILES, options)
  files = options[:long] ? long_list(files) : align_files(files)
  print_files(files)
end

def create_options
  parser = OptionParser.new
  options = {}
  parser.on('-a', '--all', 'Show all files, including those that start with .') { |opt| options[:all] = opt }
  parser.on('-r', '--reverse', 'Show files in reverse order') { |opt| options[:reverse] = opt }
  parser.on('-l', '--long', 'Show file information') { |opt| options[:long] = opt }
  begin
    parser.parse!
  rescue OptionParser::InvalidOption => e
    puts e
    puts "Try 'ruby ls.rb --help' for more information."
    exit
  end
  options
end

def customize_file_list(files, options)
  files = Dir.glob('*', File::FNM_DOTMATCH) if options[:all]
  files = files.reverse if options[:reverse]
  files
end

def long_list(files)
  max_char_length = files.map { |file| File.size(file).to_s.length }.max.to_i
  total_block_size = files.map { |file| File::Stat.new(file).blocks }.sum
  # lsコマンドで割り当てられるブロック単位は 1024 、File::Statのblocksメソッドは 512 であるので半分に割った
  puts "total #{total_block_size / 2}"
  files.map do |file|
    stat = File::Stat.new(file)
    [[FILE_TYPES[stat.ftype] + stat.mode.to_s(8)[-3..].chars.map { |x| PERMISSION_LEVELS[x] }.join,
      stat.nlink,
      Etc.getpwuid(stat.uid).name,
      Etc.getgrgid(stat.gid).name,
      stat.size.to_s.rjust(max_char_length),
      stat.mtime.strftime('%b %_d %R'), file].join(' ')]
  end
end

def align_files(files)
  rows = files.count.ceildiv(COLUMNS)
  # transposeメソッドを使用するには、行と列を入れ替えることができるように、1-2個の数字しか持たない配列を空白で埋める
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
