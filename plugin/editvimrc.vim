function! EditVimRC()
    if TabIsEmpty()
        :execute "e $MYVIMRC"
    else
        :execute "tabe $MYVIMRC"
    endif
endfunction

nnoremap <leader>ev :call EditVimRC()<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
