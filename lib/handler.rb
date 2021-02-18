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
      execute_reference_note

    when ''
      # TODO: control for multi select
      log('pressed open key')
      open_selected_file

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

  def open_selected_file
    file = open_file
    nvim.command("vsplit #{file.absolute_path}")
  end

  def new_scratch_buffer
    title = if @query_string == ''
              '<selection>'
            else
              @query_string
            end

    nvim.command("vsplit Ref:#{title}")
    nvim.command('setlocal buftype=nofile')
    nvim.command('setlocal bufhidden=hide')
    nvim.get_current_buf
  end

  def execute_reference_note
    ref = ReferenceNote.new(selected_lines, dir_path)
    ref.generate_aggregate_file
    buf = new_scratch_buffer
    ref.append_aggregate_to_buffer buf
  end
end
