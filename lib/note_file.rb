# frozen_string_literal: true

# file should be either an existing file or a new one
# by the time we get to returning the file, it should exist
#
class NoteFile
  attr_reader :dir_path, :filename, :contents

  def initialize(dir_path)
    @dir_path = dir_path

    raise_initialize_error unless @filename && @contents
  end

  def write_title(title)
    @contents[0] = "# #{title}\n"
  end

  def save
    log("save attempted on file #{filename}")
    clear_file_on_disk
    write_to_disk
    true
  end

  def absolute_path
    # control for there maybe being a / at the end
    # just for my sanity
    @absolute_path ||= "#{dir_path}/#{filename}.md"
  end

  def new_contents(new_lines)
    log("new contents set for #{absolute_path}")
    @contents = new_lines
    self
  end

  def strip_trailing_whitespace
    rev = @contents.reverse
                   .drop_while { |ln| ln == '' }

    @contents = rev.reverse
    self
  end

  private

  def clear_file_on_disk
    log("clear file on disk attempted for #{absolute_path}\n\n")
    File.write(absolute_path, '')
    log("#{filename} written with: #{File.readlines(absolute_path)}\n\n")
  end

  def write_to_disk
    log("write to disk attempted for #{absolute_path}\n\n")
    contents.each do |line|
      File.write(absolute_path, "#{line}\n", mode: 'a')
    end
    log("#{absolute_path} written with: #{File.readlines(absolute_path)}\n\n")
  end

  def read_contents
    # File.exists?(filename)
    []
  end

  def raise_initialize_error
    raise 'NoteFile should be instantiated by a subclass which sets filename and contents'
  end
end
