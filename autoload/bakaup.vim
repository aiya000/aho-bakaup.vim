
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

	call writefile(getline(1, '$'), l:location)
endfunction


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


"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"


"" Enable bakaup auto backup
function! bakaup#enable_auto_backup()
	let g:bakaup_private['default_backup'] = &backup

	" disabled default backup
	set nobackup

	" registered auto backup
	augroup BakaupBackup
		autocmd!
		autocmd BufWritePre ?\+ silent call bakaup#backup_to_dir()
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
