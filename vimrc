call pathogen#infect() 
syntax enable
filetype plugin indent on
set number
let mapleader = "'"
set wildmenu
set wildmode=list:longest

function! TabIsEmpty()
    return winnr('$') == 1 && len(expand('%')) == 0 && line2byte(line('$') + 1) <= 2
endfunction

" Edit vimrc
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

" Mappings
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
nnoremap - :normal ddp<CR>
nnoremap _ @='ddkP'<CR>
onoremap P a(
onoremap p i(
onoremap Q a"
onoremap c i{
onoremap q i"
onoremap C a{
cnoreabbrev W w
cnoreabbrev X x
cnoreabbrev Q q
cnoreabbrev tc tabclose
cnoreabbrev GA Git add %
nnoremap Y y$
set noswapfile

" Open file with spec
function! OpenBoth(left, right)
    if TabIsEmpty()
        :execute ":e " . a:right
    else
        :execute ":tabedit " . a:right
    endif
    :execute ":vsplit " . a:left
endfunction

function! OpenWithTest(filePath, type)
    let parts = split(a:filePath, '/')
    let l = len(parts)
    let file = parts[l - 1]
    let fileParts = split(file, '\.')
    let fileName = fileParts[0]
    let testPath = "specs/" . a:type . "/" . fileName . "-spec.coffee"
    if !filereadable(testPath)
        let p = split(a:filePath, '\.')
        let testPath = p[0] . 'Spec.coffee'
    endif
    call OpenBoth(testPath, a:filePath)
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

" CoffeScript mappings
function! ApplyCoffescriptMappings()
    nnoremap <buffer> ]g /Given<cr>
    nnoremap <buffer> [g ?Given<cr>
    nnoremap <buffer> ]w /When<cr>
    nnoremap <buffer> [w ?When<cr>
    nnoremap <buffer> ]t /Then<cr>
    nnoremap <buffer> [t ?Then<cr>
    nnoremap <buffer> ]i /Invariant<cr>
    nnoremap <buffer> [i ?Invariant<cr>
    nnoremap <buffer> ]a /And<cr>
    nnoremap <buffer> [a ?And<cr>
    nnoremap <buffer> ]d /describe<cr>
    nnoremap <buffer> [d ?describe<cr>
endfunction

au BufRead,BufNew *.coffee :call ApplyCoffescriptMappings()

" Remove trailing whitespace when saving 
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
    autocmd FileType json setlocal ts=4 sts=4 sw=4 expandtab
endif
