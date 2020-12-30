require 'neovim'
require 'pry'

Neovim.plugin do |plug|
  plug.command(:NV) do |nvim|
    nvim.message('hi')
    binding.pry
    # comment
  end
end
