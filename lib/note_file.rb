# frozen_string_literal: true

# file should be either an existing file or a new one
# by the time we get to returning the file, it should exist
#
class NoteFile
  attr_reader :dir_path, :filename, :contents

  def initialize(query_string, dir_path)
    @dir_path = dir_path
    @filename = generate_filename
    @contents = read_contents

    set_title query_string
    save
  end

  def set_title(title)
    @contents[0] = "# #{title}\n"
  end

  def generate_filename
    stamp = %x[date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s"].chomp
    ready = false
    try = 0

    while ready == false do
      if File.exists?("#{dir_path}/#{stamp}.md")
        try += 1
        stamp = stamp.gsub(/\d$/, try.to_s)
      else
        ready = true
      end
    end

    stamp
  end

  def save
    clear_file_on_disk
    contents.each do |line|
      File.write(absolute_path, line, mode: 'a')
    end
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
    File.write(absolute_path, "")
  end

  def read_contents
    # File.exists?(filename)
    []
  end
end
