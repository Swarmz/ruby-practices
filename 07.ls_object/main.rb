#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'file_list'
require_relative 'list_formatter'

def create_options
  parser = OptionParser.new
  options = {}
  parser.on('-a', '--all', 'Show all files, including those that start with .') { |opt| options[:all] = opt }
  parser.on('-r', '--reverse', 'Show files in reverse order') { |opt| options[:reverse] = opt }
  parser.on('-l', '--long', 'Show file information') { |opt| options[:long] = opt }
  parser.parse!
  options
end

if __FILE__ == $PROGRAM_NAME
  options = create_options
  file_list = FileList.new(options)
  formatter = ListFormatter.new(file_list, options)

  puts formatter.output
end
