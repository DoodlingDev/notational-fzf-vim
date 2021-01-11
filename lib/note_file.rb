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
    clear_file_on_disk
    write_to_disk
    true
  end

  def absolute_path
    # control for there maybe being a / at the end
    # just for my sanity
    @absolute_path ||= "#{dir_path}/#{filename}.md"
  end

  private

  def clear_file_on_disk
    # FileUtils.touch(absolute_path)
    File.write(absolute_path, '')
  end

  def write_to_disk
    contents.each do |line|
      File.write(absolute_path, line, mode: 'a')
    end
  end

  def read_contents
    # File.exists?(filename)
    []
  end

  def raise_initialize_error
    raise 'NoteFile should be instantiated by a subclass which sets filename and contents'
  end
end
