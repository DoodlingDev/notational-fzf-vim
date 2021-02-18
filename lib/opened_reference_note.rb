# frozen_string_literal: true

require_relative './reference_note'
require_relative './utils'

# reference note that reads from
# an already existing generated reference note
class OpenedReferenceNote < ReferenceNote
  attr_reader :contents

  def initialize(filename, dir_path)
    @dir_path = dir_path
    referencing_note_lines = aggregate_filepaths("#{dir_path}/#{filename}")
    filename_without_extention = File.basename(filename, '.*')
    super(referencing_note_lines, dir_path, filename_without_extention)
  end

  private

  def aggregate_filepaths(filepath)
    read_ref_file(filepath)
    parse_contents_for_individual_files
  end

  def read_ref_file(filepath)
    @contents = OpenedFile.new(filepath, dir_path).contents
  end

  def parse_contents_for_individual_files
    ref_note_filepaths = []
    @contents.each do |line|
      filematch = /<!-- %% (.*) (.*) -->/.match(line)
      next unless filematch

      absolute_path = filematch[2]
      ref_note_filepaths << "#{absolute_path}:"
    end
    ref_note_filepaths
  end
end
