# frozen_string_literal: true

require_relative './note_file'
require_relative './utils'

# OpenedFile
# when the file already exists and it needs to be opened
# instead of created from scratch
class OpenedFile < NoteFile
  def initialize(filepath, dir_path)
    log("OpenedFile attempted with filepath: #{filepath}")
    @filename = read_filename filepath
    @contents = read_contents filepath
    @dir_path = dir_path

    super(dir_path)
  end

  private

  def read_contents(filepath)
    f = File.open(filepath)
    f.readlines.map(&:chomp)
  end

  def read_filename(filepath)
    matchgroup = %r{/([^/]+)\.md}.match filepath
    log("opened file read_filename matchgroup: #{matchgroup}")
    matchgroup[1].gsub(%r{^/}, '')
  end
end
