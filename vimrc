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

function! OpenWithTest(filePath, type, mode)
    let parts = split(a:filePath, '/')
    let l = len(parts)
    let file = parts[l - 1]
    let fileParts = split(file, '\.')
    let fileName = fileParts[0]
    let testPath = "specs/" . a:type . "/" . fileName . "-spec.coffee"
    if !filereadable(testPath)
        if a:mode == '1'
            let p = split(a:filePath, '\.')
            let testPath = p[0] . 'Spec.coffee'
        elseif a:mode == '2'
            let testPath = "test/" . a:type . "/" . fileName . "-spec.coffee"
        endif
    endif
    call OpenBoth(testPath, a:filePath)
endfunction

function! OpenUnit(filePath)
    call OpenWithTest(a:filePath, 'unit', '1')
endfunction

function! OpenE2E(filePath)
    call OpenWithTest(a:filePath, 'e2e', '1')
endfunction

function! OpenIt(filePath)
    call OpenWithTest(a:filePath, 'it', '1')
endfunction

function! OpenNewUnit(filePath)
    call OpenWithTest(a:filePath, 'unit', '2')
endfunction

function! OpenNewE2E(filePath)
    call OpenWithTest(a:filePath, 'e2e', '2')
endfunction

function! OpenNewIt(filePath)
    call OpenWithTest(a:filePath, 'it', '2')
endfunction

function! OpenOldUnit(filePath)
    call OpenWithTest(a:filePath, 'unit', '0')
endfunction

function! OpenOldE2E(filePath)
    call OpenWithTest(a:filePath, 'e2e', '0')
endfunction

function! OpenOldIt(filePath)
    call OpenWithTest(a:filePath, 'it', '0')
endfunction

command! -complete=file -nargs=1 U call OpenUnit(<f-args>)
command! -complete=file -nargs=1 I call OpenIt(<f-args>)
command! -complete=file -nargs=1 E call OpenE2E(<f-args>)
command! -complete=file -nargs=1 Un call OpenNewUnit(<f-args>)
command! -complete=file -nargs=1 In call OpenNewIt(<f-args>)
command! -complete=file -nargs=1 En call OpenNewE2E(<f-args>)
command! -complete=file -nargs=1 Uo call OpenOldUnit(<f-args>)
command! -complete=file -nargs=1 Io call OpenOldIt(<f-args>)
command! -complete=file -nargs=1 Eo call OpenOldE2E(<f-args>)

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

function! Indent2Spaces()
    setlocal expandtab
    setlocal shiftwidth=2
    setlocal softtabstop=2
endfunction

au BufRead,BufNew *.coffee :call ApplyCoffescriptMappings()
au BufRead,BufNew *.coffee,*.feature,*.js,*.jsx :call Indent2Spaces()

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

let coffee_compiler = '/usr/local/bin/coffee'

let g:formatprg_js = "js-beautify"
let g:formatprg_args_js = "-s 2"
noremap <F3> :Autoformat<CR><CR>
