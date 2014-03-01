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


let mapleader = "'"
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
cnoreabbrev W w
cnoreabbrev X x
cnoreabbrev Q q
cnoreabbrev tc tabclose
set noswapfile

function! OpenWithTest(filePath, type)
    let parts = split(a:filePath, '/')
    let l = len(parts)
    let file = parts[l - 1]
    let fileParts = split(file, '\.')
    let fileName = fileParts[0]
    echo fileName
    :execute ":tabedit " . a:filePath
    :execute ":vsplit specs/" . a:type . "/" . fileName . "-spec.coffee"
endfunction

function! OpenUnit(filePath)
    call OpenWithTest(a:filePath, 'unit')
endfunction

function! OpenE2E(filePath)
    call OpenWithTest(a:filePath, 'e2e')
endfunction

function! OpenIt(filePath)
    call OpenWithTest(a:filePath, 'it')
endfunction

command! -complete=file -nargs=1 U call OpenUnit(<f-args>)
command! -complete=file -nargs=1 I call OpenIt(<f-args>)
command! -complete=file -nargs=1 E call OpenE2E(<f-args>)
