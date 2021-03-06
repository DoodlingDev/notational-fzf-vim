# frozen_string_literal: true

require 'neovim'
require_relative '../../lib/handler'
require_relative '../../lib/ref_autosave'

Neovim.plugin do |plug|
  plug.function(:NV_handler, nargs: 1) do |nvim, arg|
    reset_log
    query_string, keypress, *selected_lines = arg
    dir_path = nvim.get_var('notes_directory')
    # log(dir_path)
    # get the notes directory path from vim variable
    Handler.new(query_string: query_string,
                keypress: keypress,
                selected_lines: selected_lines,
                dir_path: dir_path,
                nvim: nvim).execute
  end

  plug.function(:NV_ref_autosave, nargs: 0) do |nvim, _arg|
    RefAutosaveHandler.new(nvim).execute
  end
end
