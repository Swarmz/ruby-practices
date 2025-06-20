# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  options = create_options
  ARGV.each do |file|
    print_files(file, options)
  end
end

def create_options
  parser = OptionParser.new
  options = {}
  parser.on('-l', '--lines', 'print the newline counts') { |opt| options[:lines] = opt }
  parser.on('-w', '--words', 'print the word counts') { |opt| options[:words] = opt }
  parser.on('-c', '--bytes', 'print the byte counts') { |opt| options[:bytes] = opt }
  begin
    parser.parse!
  rescue OptionParser::InvalidOption => e
    puts e
    puts "Try 'ruby wc.rb --help' for more information."
    exit
  end
  options
end

def print_files(file, options)
  puts [
  File.read(file).scan(/\n/).count,
  File.read(file).scan(/\w+/).count,
  file.size,
  File.basename(file)].join(' ')
end

main
