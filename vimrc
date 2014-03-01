call pathogen#infect() 
syntax enable
filetype plugin indent on
set number
let mapleader = "'"

function! TabIsEmpty()
    return winnr('$') == 1 && len(expand('%')) == 0 && line2byte(line('$') + 1) <= 2
endfunction
