# frozen_string_literal: true

class ListFormatter
  COLUMNS = 3

  FILE_TYPES = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }.freeze

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

  def initialize(list, options)
    @list = list
    @options = options
  end

  def output
    @options[:long] ? format_long : format_short
  end

  private

  def format_short
    row_count = @list.count.ceildiv(COLUMNS)
    name_width = @list.map { |file| file.name.length }.max

    columns = @list
              .map { |file| file.name.ljust(name_width + 2) }
              .each_slice(row_count)
              .to_a

    columns
      .map { |column| column.values_at(0...row_count) }
      .transpose
      .map { |row| row.join('') }
      .join("\n")
  end

  def format_long
    total_block_size = @list.sum(&:block_size)
    links_width = @list.map { |file| file.links.to_s.length }.max
    user_width = @list.map { |file| file.user.name.length }.max
    group_width = @list.map { |file| file.group.name.length }.max
    byte_width = @list.map { |file| file.byte_size.to_s.length }.max

    long_lines = @list.map do |file|
      [
        "#{file_type_character(file.file_type)}#{permission_string(file.permissions)}",
        file.links.to_s.rjust(links_width),
        file.user.name.ljust(user_width),
        file.group.name.ljust(group_width),
        file.byte_size.to_s.rjust(byte_width),
        file.edited_at.strftime('%b %_d %R'),
        file.name
      ].join(' ')
    end
    # FileStat#block_size は File::Stat#blocks (512バイト単位) をそのまま返すため、1024バイト単位(lsのtotal表示に合わせる)に変換
    ["total #{total_block_size / 2}", *long_lines].join("\n")
  end

  def permission_string(mode)
    mode.to_s(8)[-3..].chars.map { |x| PERMISSION_LEVELS[x] }.join
  end

  def file_type_character(ftype)
    FILE_TYPES[ftype]
  end
end
