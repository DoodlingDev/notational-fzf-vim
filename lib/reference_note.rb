# frozen_string_literal: true

require_relative './utils'
require_relative './opened_file'
require 'pry'

# pull in all the notes
class ReferenceNote
  attr_reader :dir_path, :refs

  def initialize(referencing_note_lines, dir_path, existing_filename = nil)
    @dir_path = dir_path
    @refs = instantiate referencing_note_lines
    @filename = existing_filename if existing_filename
    @contents = []
  end

  def absolute_path
    @absolute_path ||= "#{dir_path}/#{filename}.md"
  end

  def generate_aggregate_file
    @refs.each do |ref|
      @contents << header(ref)
      ref.contents.each do |line|
        @contents << line
      end
      @contents << ''
      @contents << ''
    end
  end

  def append_aggregate_to_buffer(buffer)
    buffer.set_lines(0, @contents.length + 1, false, @contents)
  end

  private

  def write(line)
    File.write(absolute_path, "#{line}\n", mode: 'a')
  end

  def ref_spacer
    "\n\n"
  end

  def header(ref)
    "<!-- %% #{ref.dir_path} #{ref.absolute_path} -->"
  end

  def filename
    @filename ||= Time.now.strftime('%Y%m%d-%S%4Nref')
  end

  def instantiate(note_lines)
    referencing_notes = []
    filepaths = parse_for_paths note_lines

    filepaths.uniq.each do |filepath|
      file = OpenedFile.new(filepath, dir_path)
      log("opened file dir_path: #{file.dir_path}")
      referencing_notes << file
    end
    referencing_notes
  end

  def parse_for_paths(note_lines)
    note_lines.map do |s|
      filematch = /^([^:]+):/.match(s)
      filematch[1]
    end
  end
end
