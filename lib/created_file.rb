# frozen_string_literal: true

require_relative './utils'
require_relative './note_file'

# CreatedFile
# Note File that did not previously exist
class CreatedFile < NoteFile
  def initialize(query_string, dir_path)
    @filename = generate_filename
    @contents = []
    super(dir_path)

    write_title query_string
    save
  end

  private

  # @return [String]
  def generate_filename
    Time.now.strftime('%Y%m%d-%S%4N')
  end
end
