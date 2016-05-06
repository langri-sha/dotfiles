let g:unite_data_directory='$XDG_CONFIG_HOME/nvim/unite'
let g:unite_source_history_yank_enable=1
let g:unite_prompt='» '
let g:unite_source_rec_async_command=['ag', '--follow', '--nocolor', '--nogroup','--hidden', '-g', '', '--ignore', '.git', '--ignore', 'dist']

nnoremap <silent> <C-p> :Unite -auto-resize -start-insert -direction=botright file_rec/neovim<CR>
nnoremap <silent> <leader>c :Unite -auto-resize -start-insert -direction=botright colorscheme<CR>
nnoremap <silent> <leader>u :call dein#update()<CR>
nnoremap <silent> <leader>m :Unite -auto-resize -start-insert -direction=botright redismru<CR>

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()

function! s:unite_settings() "{{{
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction "}}}
