# frozen_string_literal: true

require 'neovim'
require_relative '../../lib/created_file'
require_relative '../../lib/opened_file'

Neovim.plugin do |plug|
  plug.function(:NV_handler, nargs: 1) do |nvim, arg|
    reset_log
    query_string, keypress, *selected_lines = arg
    dir_path = nvim.get_var('notes_directory')
    # log(dir_path)
    # get the notes directory path from vim variable
    handler(query_string: query_string,
            keypress: keypress,
            selected_lines: selected_lines,
            dir_path: dir_path,
            nvim: nvim)
  end
end

def log(arg)
  File.write('/Users/aji/dev/tmp/log.txt', "#{arg}\n", mode: 'a')
end

def reset_log
  File.write('/Users/aji/dev/tmp/log.txt', '')
end

def handler(query_string:, keypress:, selected_lines:, dir_path:, nvim:)
  # log(query_string)
  # log(keypress)
  # log(selected_lines)
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
