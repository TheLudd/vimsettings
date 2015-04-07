call pathogen#infect()
syntax enable
filetype plugin indent on
set number
set incsearch
let mapleader = "'"
set wildmenu
set wildmode=list:longest
set pastetoggle=<F2>

let g:ctrlp_custom_ignore = '\v[\/](\.git|node_modules)$'
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }

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
noremap Q <nop>
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
cnoreabbrev Wa wa
cnoreabbrev Qa qa
cnoreabbrev X x
cnoreabbrev Q q
cnoreabbrev tc tabclose
cnoreabbrev GA Git add %
nnoremap Y y$
nnoremap <Right> xp
nnoremap <Left> xhP
inoremap <Right> <ESC>lxpi
inoremap <Left> <ESC>lxhPi
set noswapfile

" Ultisnips
let g:UltiSnipsEditSplit = "vertical"

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
    if fileName == 'index'
        let fileName = parts[l -2]
    endif
    if a:type == ''
        let fullPathParts = ['test'] + parts[1:l-2] + [fileName]
    elseif a:type == 'abstract'
        let fullPathParts = ['test'] + [ 'abstract-' . fileName ]
    else
        let fullPathParts = ['test', a:type ] + parts[1:l-2] + [fileName]
    endif
    let fullPath = join(fullPathParts, '/')
    let testPath = fullPath . '-test.coffee'
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

function! OpenFlatTest(filePath)
    call OpenWithTest(a:filePath, '')
endfunction

function! OpenAbstractTest(filePath)
    call OpenWithTest(a:filePath, 'abstract')
endfunction

command! -complete=file -nargs=1 U call OpenUnit(<f-args>)
command! -complete=file -nargs=1 I call OpenIt(<f-args>)
command! -complete=file -nargs=1 E call OpenE2E(<f-args>)

command! -complete=file -nargs=1 T call OpenFlatTest(<f-args>)
command! -complete=file -nargs=1 A call OpenAbstractTest(<f-args>)

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

au BufRead,BufNewFile *.cson set ft=coffee
au BufRead,BufNewFile *.coffee :call ApplyCoffescriptMappings()
au BufRead,BufNewFile *.coffee,*.feature,*.js,*.jsx :call Indent2Spaces()
au BufRead,BufNewFile *.ko set syntax=html

" Remove trailing whitespace when saving
function! <SID>StripTrailingWhitespaces()
    if exists('b:noStripWhitespace')
        return
    endif

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

autocmd BufWritePre *.snippets let b:noStripWhitespace=1
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

if has("autocmd")
    " Enable file type detection
    filetype on
    autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType json setlocal ts=4 sts=4 sw=4 expandtab
    autocmd FileType ko setlocal syntax=html
endif

let coffee_compiler = '/usr/local/bin/coffee'

let g:formatprg_js = "js-beautify"
let g:formatprg_args_js = "-s 2"
noremap <F3> :Autoformat<CR><CR>

function! TabCloseRight(bang)
    let cur=tabpagenr()
    while cur < tabpagenr('$')
        exe 'tabclose' . a:bang . ' ' . (cur + 1)
    endwhile
endfunction

function! TabCloseLeft(bang)
    while tabpagenr() > 1
        exe 'tabclose' . a:bang . ' 1'
    endwhile
endfunction

command! -bang Tcr call TabCloseRight('<bang>')
command! -bang Tcl call TabCloseLeft('<bang>')
