inoremap <leader>link [](<esc>pa)<esc>?]<CR>i
nnoremap <leader>nv :NV<CR>

nnoremap <leader>d V:s/+todo/+done/g<CR>
nnoremap <leader>bl :let @+=expand("%")<CR>:NV <C-R>+<CR>

hi mkdLink gui=underline guifg=#82B1FF
