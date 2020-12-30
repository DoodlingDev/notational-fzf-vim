require 'neovim'
require 'pry'

Neovim.plugin do |plug|
  plug.command(:NVT) do |nvim|
    nvim.message('hi')
    log
  end
end

def log
  File.write("log.txt", "data...")
end
