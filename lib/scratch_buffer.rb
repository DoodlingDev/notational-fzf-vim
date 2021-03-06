# frozen_string_literal: true

# open a new vim scratch buffer
class ScratchBuffer
  attr_reader :nvim, :query_string

  def initialize(nvim:, query_string:)
    @query_string = query_string
    @nvim = nvim
  end

  def open
    nvim.command("e Ref:#{title}")
    nvim.command('setlocal buftype=nofile')
    nvim.command('setlocal bufhidden=hide')
    nvim.command('setlocal ft=markdown')
    nvim.command('cabbrev w <c-r>=(getcmdtype()==\':\' && getcmdpos()==1 ? \'call NV_ref_autosave()\' : \'w\')<CR>')
    nvim.command('nnoremap <buffer> <leader>w :call NV_ref_autosave()<CR>')

    nvim.get_current_buf
  end

  private

  def title
    if @query_string == ''
      '<selection>'
    else
      @query_string
    end
  end
end
