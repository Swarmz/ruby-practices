# frozen_string_literal: true

require_relative 'file_stat'
require_relative 'list_formatter'

class FileList
  include Enumerable

  def initialize(options)
    @options = options
    @list = build_file_stats
  end

  def build_file_stats
    sorted_paths.map do |file|
      FileStat.new(file)
    end
  end

  def each(&block)
    @list.each(&block)
  end

  private

  def sorted_paths
    paths = Dir.glob('*', @options[:all] ? File::FNM_DOTMATCH : 0).sort
    @options[:reverse] ? paths.reverse : paths
  end
end
