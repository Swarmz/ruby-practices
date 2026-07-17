# frozen_string_literal: true

require 'minitest/autorun'
require 'tempfile'
require_relative '../file_stat'

class FileStatTest < Minitest::Test
  def test_path_name_returns_base_name
    Tempfile.create('test') do |file|
      file_stat = FileStat.new(file.path)

      assert_equal File.basename(file.path), file_stat.name
    end
  end

  def test_file_type_returns_character_for_ftype
    Tempfile.create do |file|
      assert_equal '-', FileStat.new(file.path).file_type
    end

    Dir.mktmpdir do |dir|
      assert_equal 'd', FileStat.new(dir).file_type
    end
  end

  def test_permissions_returns_characters_for_permission_level
    Tempfile.create('test') do |file|
      File.chmod(0o777, file.path)
      file_stat = FileStat.new(file.path)

      assert_equal 'rwxrwxrwx', file_stat.permissions
    end
  end

  def test_edited_at_returns_formatted_datetime
    Tempfile.create('test') do |file|
      time = Time.new(2026, 12, 31, 12, 0, 0)
      File.utime(time, time, file.path)
      file_stat = FileStat.new(file.path)

      assert_equal 'Dec 31 12:00', file_stat.edited_at
    end
  end
end
