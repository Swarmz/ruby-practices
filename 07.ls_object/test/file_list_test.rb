# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../file_list'

class FileListTest < Minitest::Test
  def test_list_order_is_alphabetical
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        File.write('a', '')
        File.write('c', '')
        File.write('b', '')

        options = {}

        list = FileList.new(options)

        assert_equal %w[a b c], list.map(&:name)
      end
    end
  end

  def test_list_order_is_reversed
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        File.write('a', '')
        File.write('c', '')
        File.write('b', '')

        options = { reverse: true }

        list = FileList.new(options)

        assert_equal %w[c b a], list.map(&:name)
      end
    end
  end

  def test_list_doesnt_show_dot_files
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        File.write('file1', '')
        File.write('file2', '')
        File.write('.file3', '')

        options = {}

        list = FileList.new(options)

        assert_equal %w[file1 file2], list.map(&:name)
      end
    end
  end

  def test_list_shows_dot_files
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        File.write('file1', '')
        File.write('file2', '')
        File.write('.file3', '')

        options = { all: true }

        list = FileList.new(options)

        assert_equal %w[. .file3 file1 file2], list.map(&:name)
      end
    end
  end
end
