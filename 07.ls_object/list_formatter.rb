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
    name_width = column_width(:name)

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
    links_width = column_width(:links)
    user_width = column_width(:user_id_name)
    group_width = column_width(:group_id_name)
    byte_width = column_width(:byte_size)

    long_lines = @list.map do |file|
      [
        "#{file.file_type}#{file.permissions}",
        file.links.to_s.rjust(links_width),
        file.user_id_name.ljust(user_width),
        file.group_id_name.ljust(group_width),
        file.byte_size.to_s.rjust(byte_width),
        file.edited_at.strftime('%b %_d %R'),
        file.name
      ].join(' ')
    end
    # FileStat#block_size は File::Stat#blocks (512バイト単位) をそのまま返すため、1024バイト単位(lsのtotal表示に合わせる)に変換
    ["total #{total_block_size / 2}", *long_lines].join("\n")
  end

  def column_width(attribute)
    @list.map { |file| file.public_send(attribute).to_s.length }.max
  end
end
