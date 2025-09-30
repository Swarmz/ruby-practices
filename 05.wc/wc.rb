# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  options = parse_options
  # 少なくとも1つが選択されるまでは、デフォルトで全てのオプションが有効
  options.each_key { |k| options[k] = true } if options.values.all? { |v| v == false }

  input = read_input
  data = input.map { |file| build_data(file[:content], name: file[:name], **options) }
  data = get_total_data(data) if data.size > 1

  lengths = get_value_lengths(data)
  formatted_data = format_data(data, lengths)
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

def build_data(input, newline: false, wordcount: false, bytesize: false, name: nil)
  data = {}
  data[:newline] = input.scan(/\n/).count if newline
  data[:wordcount] = input.split.size if wordcount
  data[:bytesize] = input.bytesize if bytesize
  data[:name] = name
  data
end

def get_total_data(data)
  totals = Hash.new(0)
  data.each do |hash|
    hash.each do |key, value|
      totals[key] += value.to_i unless key == :name
    end
  end

  data << totals.merge(name: 'total')
end

def get_value_lengths(data)
  lengths = Hash.new(0)
  data.each do |row|
    row.each do |key, value|
      lengths[key] = [lengths[key], value.to_s.length].max unless key == :name
    end
  end

  lengths
end

def format_data(data, lengths)
  data.map do |hash|
    hash.map do |key, value|
      if lengths.key?(key)
        value.to_s.rjust(lengths[key])
      # :name には `.rjust` を使わない
      else
        value.to_s
      end
    end.join(' ')
  end
end

def print_data(formatted_data)
  formatted_data.each { |row| puts row }
end

main
