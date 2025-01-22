# frozen_string_literal: true

def main
  find_files
end

def find_files
  files = Dir.new(Dir.pwd).each_child.filter_map { |file| file unless file.start_with?('.') }.sort
  arrange_files(files)
end

def arrange_files(files)
  columns = 3
  rows = (files.count.to_f / columns).ceil
  # transpose メソッドを使用するには、行と列を入れ替えることができるように、1-2個の数字しか持たない配列をnilで埋める
  split_files = files.each_slice(rows).to_a.tap { |array| array.last.fill(nil, array.last.length, rows - array.last.length) }
  print_files(split_files.transpose)
end

def print_files(files)
  files.each do |row|
    row.each do |file_name|
      print file_name.ljust(20) unless file_name.nil?
    end
    print "\n"
  end
end

main
