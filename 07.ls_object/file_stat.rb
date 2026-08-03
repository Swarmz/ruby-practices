# frozen_string_literal: true

require 'etc'

class FileStat
  attr_reader :path

  def initialize(path)
    @path = path
    @stat = build_stat
  end

  def name
    File.basename(@path)
  end

  def file_type
    @stat.ftype
  end

  def permissions
    @stat.mode
  end

  def links
    @stat.nlink
  end

  def user
    Etc.getpwuid(@stat.uid)
  end

  def group
    Etc.getgrgid(@stat.gid)
  end

  def byte_size
    @stat.size
  end

  def edited_at
    @stat.mtime
  end

  def block_size
    @stat.blocks
  end

  private

  def build_stat
    File.lstat(@path)
  end
end
