# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  options = parse_options
  # 少なくとも1つが選択されるまでは、デフォルトで全てのオプションが有効
  options.each_key { |k| options[k] = true } if options.values.all? { !it }

  input = read_input
  file_stats = input.map { |file| build_file_stats(file[:content], name: file[:name], **options) }
  file_stats = build_file_stats_total(file_stats) if file_stats.size > 1

  formatted_stats = format_file_stats(file_stats)
  print_file_stats(formatted_stats)
end

def parse_options
  options = { line_count: false, word_count: false, byte_size: false }
  parser = OptionParser.new do |opts|
    opts.on('-l', '--lines', 'print the line counts') { |opt| options[:line_count] = opt }
    opts.on('-w', '--words', 'print the word counts') { |opt| options[:word_count] = opt }
    opts.on('-c', '--bytes', 'print the byte counts') { |opt| options[:byte_size] = opt }
  end
  parser.parse!(ARGV)
  options
end

def read_input
  # STDIN を読み込む場合でも常にハッシュの配列を返す。
  # そうすることで build_file_stats メソッドが一貫して同じ方法で反復処理できる。
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

def build_file_stats(input, line_count: false, word_count: false, byte_size: false, name: nil)
  stats = {}
  stats[:line_count] = input.scan(/\n/).count if line_count
  stats[:word_count] = input.split.size if word_count
  stats[:byte_size] = input.bytesize if byte_size
  stats[:name] = name
  stats
end

def build_file_stats_total(file_stats)
  total = Hash.new(0)

  file_stats.first.each_key do |key|
    total[key] = file_stats.sum { |stats| stats[key] } unless key == :name
  end

  total_row = total.merge(name: 'total')
  file_stats + [total_row]
end

def format_file_stats(file_stats)
  file_stats.map do |stats|
    stats.map do |key, value|
      if key == :name
        value
      else
        value.to_s.rjust(column_widths(file_stats, key))
      end
    end.join(' ')
  end
end

def column_widths(file_stats, key)
  file_stats.map { |stats| stats[key].to_s.length }.max
end

def print_file_stats(formatted_stats)
  formatted_stats.each { |stats| puts stats }
end

main
