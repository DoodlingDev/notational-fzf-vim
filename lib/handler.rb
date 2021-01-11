# frozen_string_literal: true

require_relative './utils'
require_relative './created_file'
require_relative './opened_file'

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

    when ''
      # TODO: control for multi select
      filepath = /^([^:]+):/.match(selected_lines[0])

      file = if filepath && (File.exist? filepath[1])
               OpenedFile.new(filepath[1], dir_path)
             else
               CreatedFile.new(query_string, dir_path)
             end

      nvim.command("vsplit #{file.absolute_path}")

    else
      log('pressed something else')
      # nothing?

    end
  end
end
