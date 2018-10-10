let s:V = vital#bakaup#new()

let s:Msg = s:V.import('Vim.Message')
let s:Either = s:V.import('Data.Either')

" Backs up a file into the directory.
function! bakaup#backup_to_dir() abort
    " Make a directory for today's backing up
    let daily_dir = g:bakaup_backup_dir . '/' . strftime('%Y-%m-%d')
    if !isdirectory(daily_dir)
        call mkdir(daily_dir, 'p', 0700)
    endif

    let target_file = has('win32')
        \ ? substitute(expand('%:p'), ':', '%', 'g')
        \ : expand('%:p')
    let suffix = strftime(has('win32') ? '_at_%H-%M' : '_at_%H:%M')
    let backup_file = substitute(target_file, '/', '%', 'g') . suffix
    let backup_file = daily_dir . '/' . backup_file

    " NOTE: Don't use readfile() at here, because it fails with `nofile` files
    call writefile(getline(1, '$'), backup_file)
endfunction

" Enables automatic backing up
function! bakaup#enable_auto_backup()
    augroup BakaupBackup
        autocmd!
        autocmd BufWritePre ?\+ call bakaup#backup_to_dir()
    augroup END
endfunction

" Disables automatic backing up
function! bakaup#disable_auto_backup()
    try
        augroup! BakaupBackup
    catch /E367/
        " Ignore the error that the augroup were not existent
    endtry
endfunction

" Makes the archive with backed up files
function! bakaup#archive_backups() abort
    if !executable('tar')
        call s:Msg.error("aho-bakaup.vim needed tar command, but it couldn't be found x(")
        return
    endif

    if !isdirectory(g:bakaup#archive_dir)
        call mkdir(g:bakaup#archive_dir, 'p', 0700)
    endif

    call s:Either.bimap(s:make_archive(),
        \ { msg -> s:Msg.echo('None', msg) },
        \ { msg -> s:Msg.echo('Error', msg) }
    \ )
endfunction

function! s:make_archive() "{{{
    let DAILY_PATTERN = '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$' | lockvar DAILY_PATTERN
    let files = map(
        \ systemlist(printf('ls %s', g:bakaup_backup_dir)),
        \ { _, file -> fnamemodify(file, ':t') }
    \ )
    let files = map(files, { _, file -> fnameescape(file) })
    let files = filter(files, { _, x -> x =~# DAILY_PATTERN })
    if empty(files)
        return s:Either.right('Did nothing, befcause the targets were nothing.')
    endif

    let archive_file = 'vim-bakaup_' . strftime('%Y-%m-%d', localtime()) . '.tar.bz2'
    let archive_path = g:bakaup#archive_dir . '/' . archive_file
    let target_path  = g:bakaup_backup_dir . '/' . s:make_glob_pattern(files)

    " Make the archive
    let tar_result = system(printf('tar jcvf %s %s', archive_path, target_path))
    if v:shell_error isnot 0
        return s:Either.left(tar_result)
    endif

    " Remove the archived directories
    let rm_result = system(printf('rm -rf %s ; echo $?', target_path))
    if v:shell_error isnot 0
        return s:Either.left('rm_result')
    endif

    return s:Either.right('Success!')
endfunction "}}}

" Makes a glob pattern like "{foo,bar,baz}" or "foo".
"
" Makes a pattern of "{foo,bar,baz}" if the taken argument is plural file,
" or makes a pattern of "foo" if the taken argument is a file.
function! s:make_glob_pattern(files) "{{{
    return len(a:files) > 1
        \ ? printf('{%s}', join(a:files, ','))
        \ : a:files[0]
endfunction "}}}

" Sets variables based on the taken directory.
function! bakaup#set_bakaup_dir(dir)
    let g:bakaup_backup_dir  = a:dir
    let g:bakaup#archive_dir = a:dir . '/archive'
endfunction

" Opens netrw with the backup directory.
" @param arguments 'tab', 'vertical', 'horizon', or empty.
function! bakaup#explore(...)
    if empty(a:000)
        execute ':Explore' g:bakaup_backup_dir
    elseif a:1 ==# 'tab'
        execute ':Texplore' g:bakaup_backup_dir
    elseif a:1 ==# 'vertical'
        execute ':Vexplore' g:bakaup_backup_dir
    elseif a:1 ==# 'horizon'
        execute ':Sexplore' g:bakaup_backup_dir
    else
        throw 'an unexpected arguments: ' . string(a:000)
    endif
endfunction
