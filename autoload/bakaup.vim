" make directory and set owner
" args => a:dir :: String
function! s:mkdir_with_conditions(dir)
	call mkdir(a:dir, 'p', 0700)

	if has('unix') && executable('chown')
		let l:username  = $USER
		let l:groupname = $GROUP !=# '' ? $GROUP : $USER
		let l:command   = printf('chown -R %s:%s %s', l:username, l:groupname, a:dir)
		call system(l:command)
	endif
endfunction


function! s:echo_error(msg)
	echohl Error
	echo a:msg
	echohl None
endfunction


"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"


"" Execute backup file to backup directory
"" Backup directory depends localtime
function! bakaup#backup_to_dir()
	" base directory for file backup at today
	let l:dailydir = g:bakaup_backup_dir . '/' . strftime('%Y-%m-%d')

	if !isdirectory(l:dailydir)
		call s:mkdir_with_conditions(l:dailydir)
	endif

	let l:sub_extension = strftime(has('win32') ? '_at_%H-%M' : '_at_%H:%M')
	let l:filename      = expand('%:t') . l:sub_extension
	let l:location      = l:dailydir . '/' . l:filename

	" If editing exists file, backup detail of before :write
	" or backup current detail
	if filereadable(expand('%:p'))
		call writefile(readfile(expand('%:p')), l:location)
	else
		call writefile(getline(1, '$'), l:location)
	endif
endfunction


"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"


"" Enable bakaup auto backup
function! bakaup#enable_auto_backup()
	let g:bakaup_private['default_backup'] = &backup

	" disabled default backup
	set nobackup

	" registered auto backup
	augroup BakaupBackup
		autocmd!
		autocmd BufWritePre ?\+ call bakaup#backup_to_dir()
	augroup END
endfunction


"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"


"" Disable bakaup auto backup
function! bakaup#disable_auto_backup()
	" registered auto backup
	let &backup = g:bakaup_private['default_backup']

	try
		" unregistered auto backup
		augroup! BakaupBackup
	catch /E367/
		" ignored an error
	endtry
endfunction


"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"


"" Archive backup files
function! bakaup#archive_backups()
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


function! s:bakaup_archiver()
	let l:daily_pattern = '^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'
	let l:ls_cmd     = printf('ls %s | grep "%s"', g:bakaup_backup_dir, l:daily_pattern)
	let l:backed_ups = split(system(l:ls_cmd), "\n")

	" If backed up files is nothing
	if len(l:backed_ups) < 1
		" nothing to do
		return 1
	endif

	" Prepare shell command
	let l:archive_name = 'vim-bakaup_' . strftime('%Y-%m-%d', localtime()) . '.tar.bz2'
	let l:glob_format  = s:to_globf(l:backed_ups)
	let l:tar_cmd = printf('tar jcvf %s/%s %s/%s ; echo $?',
	\			g:bakaup_private['archive_dir'], l:archive_name, g:bakaup_backup_dir, l:glob_format)

	" Archive backup directoris
	let l:tar_result = system(l:tar_cmd)
	if split(l:tar_result, "\n")[-1] !=# 0
		throw l:tar_result
	endif

	" Remove backed up directories
	let l:rm_cmd    = 'rm -rf ' . printf('%s/%s', g:bakaup_backup_dir, l:glob_format) . '; echo $?'
	let l:rm_result = system(l:rm_cmd)
	if split(l:rm_result, "\n")[-1] !=# 0
		throw l:rm_result
	endif

	return 0
endfunction


" file_names to glob pattern of {..,..,..}
function! s:to_globf(files)
	" If a:files is single file, no glob a file
	" If a:files is many files, glob files
	return len(a:files) > 1
	\    ? '{' . join(a:files, ',') . '}'
	\    : a:files[0]
endfunction
