# frozen_string_literal: true

def log(arg)
  File.write('/Users/aji/dev/tmp/log.txt', "#{arg}\n", mode: 'a')
end

def reset_log
  File.write('/Users/aji/dev/tmp/log.txt', '')
end
