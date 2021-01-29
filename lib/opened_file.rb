# frozen_string_literal: true

require_relative './note_file'
require_relative './utils'

# OpenedFile
# when the file already exists and it needs to be opened
# instead of created from scratch
class OpenedFile < NoteFile
  def initialize(filepath, dir_path)
    @filename = read_filename filepath
    @contents = read_contents filepath

    super(dir_path)
  end

  private

  def read_contents(filepath)
    f = File.open(filepath)
    f.readlines.map(&:chomp)
  end

  def read_filename(filepath)
    matchgroup = %r{/([^/]+)\.md}.match filepath
    matchgroup[1].gsub(%r{^/}, '')
  end
end
