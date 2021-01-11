# frozen_string_literal: true
#
require_relative './note_file.rb'

class CreatedFile < NoteFile
  def initialize(query_string, dir_path)
    super(dir_path)
    @filename = generate_filename
    @contents = []

    set_title query_string
    save
  end
end
