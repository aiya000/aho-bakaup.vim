" make directory and set owner
" args => a:dir :: String
function! s:mkdir_with_conditions(dir) "{{{
	call mkdir(a:dir, 'p', 0700)

	if has('unix') && executable('chown')
		let l:username  = $USER
		let l:groupname = $GROUP !=# '' ? $GROUP : $USER
		let l:command   = printf('chown -R %s:%s %s', l:username, l:groupname, a:dir)
		call system(l:command)
	endif
endfunction "}}}


function! s:echo_error(msg) "{{{
	echohl Error
	echo a:msg
	echohl None
endfunction "}}}


function! s:get_files(dir) "{{{
	let l:files_str = glob(a:dir . '/*')
	let l:files     = split(l:files_str, '\n')
	return l:files
endfunction "}}}


"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"


"" Execute backup file to backup directory
"" Backup directory depends localtime
function! bakaup#backup_to_dir() abort
	" base directory for file backup at today
	let l:dailydir = g:bakaup_backup_dir . '/' . strftime('%Y-%m-%d')

	if !isdirectory(l:dailydir)
		call s:mkdir_with_conditions(l:dailydir)
	endif

	let l:filename      = expand('%:p')
	let l:filename1     = has('win32') ? substitute(l:filename, ':', '%', 'g') : l:filename

	let l:sub_extension = strftime(has('win32') ? '_at_%H-%M' : '_at_%H:%M')

	let l:backup_name   = substitute(l:filename1, '/', '%', 'g') . l:sub_extension
	let l:location      = l:dailydir . '/' . l:backup_name

	" If editing exists file, backup detail of before :write
	" or backup current detail
	if filereadable(l:filename)
		call writefile(readfile(l:filename), l:location)
	else
		call writefile(getline(1, '$'), l:location)
	endif
endfunction


"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"


"" Enable bakaup auto backup
function! bakaup#enable_auto_backup()
	" registered auto backup
	augroup BakaupBackup
		autocmd!
		autocmd BufWritePre ?\+ call bakaup#backup_to_dir()
	augroup END
endfunction


"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"


"" Disable bakaup auto backup
function! bakaup#disable_auto_backup()
	try
		" unregistered auto backup
		augroup! BakaupBackup
	catch /E367/
		" ignored an error
	endtry
endfunction


"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"


"" Archive backup files
function! bakaup#archive_backups() abort
	if !executable('tar')
		call s:echo_error('sorry, bakaup archiver needs tar command')
		return
	endif

	if !isdirectory(g:bakaup_private['archive_dir'])
		call s:mkdir_with_conditions(g:bakaup_private['archive_dir'])
	endif

	let l:result =  s:bakaup_archiver()
	if l:result is 0
		echo 'bakaup archive succeed'
	else
		echo 'backed up files is nothing, nothing todo.'
	endif
endfunction


" If do it, return 0
" If don't it, return 1
function! s:bakaup_archiver() "{{{
	let l:daily_pattern = '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$'
	let l:dirs          = s:get_files(g:bakaup_backup_dir)
	let l:names         = map(l:dirs, 'fnamemodify(v:val, ":t")')
	let l:names1        = map(l:names, 'fnameescape(v:val)')
	let l:backed_ups    = filter(l:names1, printf('v:val =~# "%s"', l:daily_pattern))

	" If backed up files is nothing
	if len(l:backed_ups) < 1
		" nothing to do
		return 1
	endif

	" Prepare shell command
	let l:archive_name = 'vim-bakaup_' . strftime('%Y-%m-%d', localtime()) . '.tar.bz2'
	let l:glob_format  = s:to_globf(l:backed_ups)

	let l:archive_path = g:bakaup_private['archive_dir'] . '/' . l:archive_name
	let l:target_path  = g:bakaup_backup_dir . '/' . l:glob_format
	let l:tar_cmd      = printf('tar jcvf %s %s ; echo $?', l:archive_path, l:target_path)

	" Archive backup directories
	let l:tar_result      = system(l:tar_cmd)
	let l:tar_return_code = split(l:tar_result, '\n')[-1]
	if l:tar_return_code !=# 0
		throw l:tar_result
	endif

	" Clean backed up directories
	let l:rm_cmd         = printf('rm -rf %s ; echo $?', l:target_path)
	let l:rm_result      = system(l:rm_cmd)
	let l:rm_return_code = split(l:rm_result, '\n')[-1]
	if l:rm_return_code !=# 0
		throw l:rm_result
	endif

	return 0
endfunction "}}}


" file_names to glob pattern of {..,..,..}
function! s:to_globf(files) "{{{
	" If a:files is single file, no glob a file
	" If a:files is many files, glob files
	return len(a:files) > 1
	\    ? '{' . join(a:files, ',') . '}'
	\    : a:files[0]
endfunction "}}}


"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"


"" Set bakaup variable, that for expected directory
"" dir => new backup directory
function! bakaup#set_bakaup_dir(dir)
	let l:archive_dir                   = a:dir . '/archive'
	let g:bakaup_backup_dir             = a:dir
	let g:bakaup_private['archive_dir'] = l:archive_dir
endfunction


"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"


"" Explorer open backup directory
"" args => a:0 = empty, 'tab', 'vertical', or 'horizon'
function! bakaup#explore(...)
	if empty(a:000)
		execute ':Explore' g:bakaup_backup_dir
	elseif a:1 ==# 'tab'
		execute ':Texplore' g:bakaup_backup_dir
	elseif a:1 ==# 'vertical'
		execute ':Vexplore' g:bakaup_backup_dir
	elseif a:1 ==# 'horizon'
		execute ':Sexplore' g:bakaup_backup_dir
	endif
endfunction
