# frozen_string_literal: true

class ListFormatter
  COLUMNS = 3

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
    max_name_length = @list.map { |file| file.name.length }.max

    columns = @list
              .map { |file| file.name.ljust(max_name_length + 2) }
              .each_slice(row_count)
              .to_a

    columns
      .map { |column| column.values_at(0...row_count) }
      .transpose
      .map { |row| row.join('') }
      .join("\n")
  end

  def format_long
    max_size_length = @list.map { |file| file.byte_size.to_s.length }.max
    total_block_size = @list.sum(&:block_size)

    long_lines = @list.map do |file|
      [
        "#{file.file_type}#{file.permissions}",
        file.links,
        file.user_id_name,
        file.group_id_name,
        file.byte_size.to_s.rjust(max_size_length),
        file.edited_at,
        file.name
      ].join(' ')
    end
    # FileStat#block_size は File::Stat#blocks (512バイト単位) をそのまま返すため、1024バイト単位(lsのtotal表示に合わせる)に変換
    ["total #{total_block_size / 2}", *long_lines].join("\n")
  end
end
