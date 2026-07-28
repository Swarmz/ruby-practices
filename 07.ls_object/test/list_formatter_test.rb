# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../list_formatter'

class ListFormatterTest < Minitest::Test
  FakeFile = Struct.new(
    :name,
    :file_type,
    :permissions,
    :links,
    :user_id_name,
    :group_id_name,
    :byte_size,
    :edited_at,
    :block_size,
    keyword_init: true
  )

  def fake_file(**attrs)
    FakeFile.new(
      {
        name: 'default',
        file_type: '-',
        permissions: 'rw-r--r--',
        links: 1,
        user_id_name: 'test',
        group_id_name: 'TEST',
        byte_size: 100,
        edited_at: Time.new(2026, 7, 14, 12, 0, 0),
        block_size: 8
      }.merge(attrs)
    )
  end

  def test_short_list_returns_single_row
    list = [
      fake_file(name: 'file1'),
      fake_file(name: 'file2'),
      fake_file(name: 'file3')
    ]

    options = {}

    formatter = ListFormatter.new(list, options)

    expected = 'file1  file2  file3  '

    assert_equal expected, formatter.output
  end

  def test_short_list_prints_vertically
    list = (1..9).map do |i|
      fake_file(name: "file#{i}")
    end

    options = {}

    formatter = ListFormatter.new(list, options)

    expected = "file1  file4  file7  \nfile2  file5  file8  \nfile3  file6  file9  "

    assert_equal expected, formatter.output
  end

  def test_long_list_prints_columns_in_order
    list = [
      fake_file(
        name: 'testing.txt',
        file_type: '-',
        permissions: 'rw-rw-rw-',
        links: 1,
        user_id_name: 'test_user',
        group_id_name: 'test_group',
        byte_size: 100,
        edited_at: Time.new(2026, 7, 14, 12, 0, 0),
        block_size: 16
      )
    ]

    options = { long: true }

    formatter = ListFormatter.new(list, options)

    expected = <<~TEXT.chomp
      total 8
      -rw-rw-rw- 1 test_user test_group 100 Jul 14 12:00 testing.txt
    TEXT

    assert_equal expected, formatter.output
  end

  def test_long_list_displays_total_block_size
    list = [
      fake_file(name: 'a', block_size: 8),
      fake_file(name: 'b', block_size: 16)
    ]

    options = { long: true }

    formatter = ListFormatter.new(list, options)

    expected = <<~TEXT.chomp
      total 12
      -rw-r--r-- 1 test TEST 100 Jul 14 12:00 a
      -rw-r--r-- 1 test TEST 100 Jul 14 12:00 b
    TEXT

    assert_equal expected, formatter.output
  end

  def test_long_list_column_alignment
    list = [
      fake_file(user_id_name: 'gavin', group_id_name: 'gavin', byte_size: 1, links: 5),
      fake_file(user_id_name: 'root', group_id_name: 'rootgroup', byte_size: 10, links: 50),
      fake_file(user_id_name: 'verylongusername', group_id_name: 'x', byte_size: 100, links: 500)
    ]

    options = { long: true }

    formatter = ListFormatter.new(list, options)

    expected = <<~TEXT.chomp
      total 12
      -rw-r--r--   5 gavin            gavin       1 Jul 14 12:00 default
      -rw-r--r--  50 root             rootgroup  10 Jul 14 12:00 default
      -rw-r--r-- 500 verylongusername x         100 Jul 14 12:00 default
    TEXT

    assert_equal expected, formatter.output
  end
end
