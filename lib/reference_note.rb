# frozen_string_literal: true

require_relative './utils'
require 'pry'

# pull in all the notes
class ReferenceNote
  attr_reader :dir_path

  def initialize(referencing_note_lines, dir_path)
    @dir_path = dir_path
    @refs = instantiate referencing_note_lines
    generate_aggregate_file
  end

  def absolute_path
    @abs_path ||= "#{dir_path}/#{filename}.md"
  end

  private

  def generate_aggregate_file
    @refs.each do |ref|
      write header(ref)
      ref.contents.each do |line|
        write line
      end
      write ref_spacer
    end
  end

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
    filepaths = note_lines.map do |s|
      filematch = /^([^:]+):/.match(s)
      filematch[1]
    end

    filepaths.uniq.each do |filepath|
      file = OpenedFile.new(filepath, dir_path)
      referencing_notes << file
    end
    referencing_notes
  end
end
