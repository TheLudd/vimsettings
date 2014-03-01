function! OpenWithTest(filePath, type)
    let parts = split(a:filePath, '/')
    let l = len(parts)
    let file = parts[l - 1]
    let fileParts = split(file, '\.')
    let fileName = fileParts[0]
    echo fileName
    if TabIsEmpty()
        :execute ":e " . a:filePath
    else
        :execute ":tabedit " . a:filePath
    endif
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
