#!/usr/bin/env ruby

HEADLINE_LENGTH = 30

BLACK = "\u001b[30m"
RED = "\u001b[31m"
GREEN = "\u001b[32m"
YELLOW = "\u001b[33m"
BLUE = "\u001b[34m"
MAGENTA = "\u001b[35m"
CYAN = "\u001b[36m"
WHITE = "\u001b[37m"
RESET = "\u001b[0m"

def format_headline(headline)
  return_buffer = headline.gsub(/^# /, '')

  if return_buffer.length >= HEADLINE_LENGTH
    return_buffer = "#{return_buffer[0..HEADLINE_LENGTH-3]}.."
  end

  return_buffer.ljust(HEADLINE_LENGTH)
end

ARGF.read.split("\n").each do |a|
  list = a.split(":")
  filename = list[0]
  line_number = list[1]
  match = list[2]
  headline = File.open(filename, &:readline).chomp

  r = "#{filename}:#{line_number}:#{MAGENTA}#{format_headline headline}#{RED} : #{WHITE} #{match}#{RESET}"

  #File.write("/Users/aji/dev/tmp/log.txt", r + "\n", mode: 'a')

  puts r
end
