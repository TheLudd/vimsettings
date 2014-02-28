call pathogen#infect() 
syntax enable
filetype plugin indent on
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap - ddp
noremap _ ddkP
set number
onoremap p i(
onoremap P a(
onoremap q i"
onoremap Q a"
onoremap b i]
onoremap B a]
onoremap c i{
onoremap C a{

function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

autocmd BufWritePre *.coffee,*.js :call <SID>StripTrailingWhitespaces()
if has("autocmd")
    " Enable file type detection
    filetype on
    autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
endif
