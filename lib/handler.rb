# frozen_string_literal: true

require_relative './utils'
require_relative './created_file'
require_relative './opened_file'
require_relative './reference_note'

# take in input from neovim and do something with it
class Handler
  attr_reader :query_string, :keypress, :selected_lines, :dir_path, :nvim

  def initialize(query_string:, keypress:, selected_lines:, dir_path:, nvim:)
    @query_string = query_string
    @keypress = keypress
    @selected_lines = selected_lines
    @dir_path = dir_path
    @nvim = nvim
  end

  def execute
    case keypress
    when 'ctrl-r'
      log('pressed ref key')
      # make ref
      # log @selected_lines

      # referencing_notes = []
      # @selected_lines.each do |s|
      #   filepath = /^([^:]+):/.match(s)
      #   file = OpenedFile.new(filepath[1], dir_path)
      #   referencing_notes << file
      # end

      # log referencing_notes

      ref = ReferenceNote.new(selected_lines, dir_path)
      nvim.command("vsplit #{ref.absolute_path}")

    when ''
      # TODO: control for multi select
      file = open_file
      nvim.command("vsplit #{file.absolute_path}")

    else
      log('pressed something else')

      # nothing?

    end
  end

  private

  def open_file
    filepath = /^([^:]+):/.match(selected_lines[0])

    if filepath && (File.exist? filepath[1])
      OpenedFile.new(filepath[1], dir_path)
    else
      CreatedFile.new(query_string, dir_path)
    end
  end

  def create_ref; end
end
