require 'neovim'
require_relative '../../lib/note_file.rb'


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
  File.write("/Users/aji/dev/tmp/log.txt", arg.to_s + "\n", mode: 'a')
end

def reset_log
  File.write("/Users/aji/dev/tmp/log.txt", '')
end

def handler(query_string:, keypress:, selected_lines:, dir_path:, nvim:)
  # log(query_string)
  # log(keypress)
  # log(selected_lines)
  case keypress
  when "ctrl-r"
    log("pressed ref key")
    # make ref

  when ""
    # TODO: control for multi select
    # log("pressed enter")
    filepath = /^([^:]+)\:/.match(selected_lines[0])

    open_file = if filepath && (File.exists? filepath[1])
      filepath[1]
    else
      file = NoteFile.new(query_string, dir_path)
      file.absolute_path
    end
    # make or open
    nvim.command("vsplit #{open_file}")


  else
    log("pressed something else")
    # nothing? ¯\_(ツ)_/¯

  end
end

