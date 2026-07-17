# frozen_string_literal: true

require 'etc'

class FileStat
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

  attr_reader :path

  def initialize(path)
    @path = path
    @stat = build_stat
  end

  def name
    File.basename(@path)
  end

  def file_type
    FILE_TYPES[@stat.ftype]
  end

  def permissions
    @stat.mode.to_s(8)[-3..].chars.map { |x| PERMISSION_LEVELS[x] }.join
  end

  def links
    @stat.nlink
  end

  def user_id_name
    Etc.getpwuid(@stat.uid).name
  end

  def group_id_name
    Etc.getgrgid(@stat.gid).name
  end

  def byte_size
    @stat.size
  end

  def edited_at
    @stat.mtime.strftime('%b %_d %R')
  end

  def block_size
    @stat.blocks
  end

  private

  def build_stat
    File::Stat.new(@path)
  end
end
