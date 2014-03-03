function! EditFile(path)
    if TabIsEmpty()
        :execute "e " . a:path
    else
        :execute "tabe " . a:path
    endif
endfunction

nnoremap <leader>ev :call EditFile("$MYVIMRC")<cr>
nnoremap <leader>em :call EditFile("~/.vim/plugin/mappings.vim")<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
