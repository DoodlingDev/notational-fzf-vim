# frozen_string_literal: true

require 'neovim'
require_relative './utils'

# handles taking in the buffer with potential
# changes and saving them back to their respective
# files on disk
class RefAutosaveHandler
  attr_reader :nvim, :buffer, :contents

  def initialize(nvim, *_args)
    @nvim = nvim
  end

  def execute
    # get buffer
    @buffer = nvim.get_current_buf
    # read in contents of buffer
    line_count = buffer.line_count
    @contents = buffer.get_lines(0, line_count, false)
    # split contents by file
    # /^<!--\s%%\s\S+\s(\S+\/([^\/\s]+))\s-->$/
    # above regex the title lines
    current_note = {
      contents: [],
      absolute_path: nil,
      dir_path: nil
    }

    @contents.each do |line|
      line_matcher = %r{^<!--\s%%\s\S+\s((\S+)/([^/\s]+))\s-->$}.match(line)
      if line_matcher
        if current_note[:absolute_path].nil?
          log('first iteration, should only see me once')
          current_note[:absolute_path] = line_matcher[1]
          current_note[:contents]      = []
          current_note[:dir_path]      = line_matcher[2]
          log("after setup current_note: #{current_note}")
          next
        end
        # current_note[:absolute_path] = line_matcher[1]
        # current_note[:dir_path]      = line_matcher[2]
        # filename = line_matcher[3]

        # next unless current_note[:filepath] && current_note[:contents].length.positive?

        log("current contents - #{current_note[:contents]}")
        # save what we've got into a file
        OpenedFile.new(current_note[:absolute_path],
                       current_note[:dir_path])
                  .new_contents(current_note[:contents])
                  .strip_trailing_whitespace
                  .save

        # current_filepath set
        current_note[:absolute_path] = line_matcher[1]
        current_note[:contents]      = []
        current_note[:dir_path]      = line_matcher[2]
        # current_contents set to []
      else
        log("appending line to #{current_note[:absolute_path]}")
        current_note[:contents] << line
      end
    end

    if current_note[:absolute_path] && current_note[:contents].length.positive?
      OpenedFile.new(current_note[:absolute_path],
                     current_note[:dir_path])
                .new_contents(current_note[:contents])
                .strip_trailing_whitespace
                .save
    end

    # - each file
    #   identify filepath
    #   remove ref note whitespace
    #   join contents and File.write
  end
end
