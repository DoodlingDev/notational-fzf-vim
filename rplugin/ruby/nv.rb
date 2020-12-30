require 'neovim'

Neovim.plugin do |plug|
  plug.command(:NV) do |nvim|
    nvim.message('hi')
    # comment
  end
end
