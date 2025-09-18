# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  options = parse_options
  options.each_key { |k| options[k] = true } if options.values.all? { |v| v == false }

  input = read_input
  data = input.map { |file| build_data(file[:content], name: file[:name], **options) }

  data = get_total_data(data) if data.size > 1

  formatted_data = format_data(data)
  print_data(formatted_data)
end

def parse_options
  options = { newline: false, wordcount: false, bytesize: false }
  parser = OptionParser.new do |opts|
    opts.on('-l', '--lines', 'print the newline counts') { |opt| options[:newline] = opt }
    opts.on('-w', '--words', 'print the word counts') { |opt| options[:wordcount] = opt }
    opts.on('-c', '--bytes', 'print the byte counts') { |opt| options[:bytesize] = opt }
  end
  parser.parse!(ARGV)
  options
end

def read_input
  # STDIN を読み込む場合でも常にハッシュの配列を返す。
  # そうすることで build_data メソッドが一貫して同じ方法で反復処理できる。
  if ARGV.length.positive?
    ARGV.map do |file|
      {
        content: File.read(file),
        name: File.basename(file)
      }
    end
  else
    [{ content: $stdin.read }]
  end
end

def build_data(input, name: nil, newline: false, wordcount: false, bytesize: false)
  data = {}
  data[:name] = name
  data[:newline] = input.scan(/\n/).count if newline
  data[:wordcount] = input.split.size if wordcount
  data[:bytesize] = input.bytesize if bytesize
  data
end

def get_total_data(data)
  newline_total = data.map { |v| v[:newline] }.sum
  wordcount_total = data.map { |v| v[:wordcount] }.sum
  bytesize_total = data.map { |v| v[:bytesize] }.sum
  data << { newline: newline_total, wordcount: wordcount_total, bytesize: bytesize_total, name: 'total' }
end

def format_data(data)
  line_size = data.map { |hash| hash[:newline].to_s.length }.max
  word_size = data.map { |hash| hash[:wordcount].to_s.length }.max
  byte_size = data.map { |hash| hash[:bytesize].to_s.length }.max

  data.map do |row|
    line_str  = row[:newline].to_s.rjust(line_size)
    word_str  = row[:wordcount].to_s.rjust(word_size)
    byte_str  = row[:bytesize].to_s.rjust(byte_size)
    name_str  = row[:name].to_s

    # nil に対して `to_s` を呼ぶと空文字列 "" になり、`join(' ')` で不要な空白が生成される。
    # そのため `reject { |str| str.empty? }` によってこの挙動を防いでいる。
    [line_str, word_str, byte_str, name_str].reject(&:empty?).join(' ')
  end
end

def print_data(formatted_data)
  formatted_data.each { |data| puts data }
end

main
