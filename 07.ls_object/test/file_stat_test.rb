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
end
