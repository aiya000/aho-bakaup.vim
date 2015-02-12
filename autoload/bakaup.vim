
" Execute backup file to backup directory
" Backup directory depends localtime
function! bakaup#backup_to_dir()
	let l:dailydir = g:bakaup_backup_dir . '/' . strftime('%Y-%m-%d')

	if !isdirectory(l:dailydir)
		call s:mkdir_with_condition(l:dailydir)
	endif

	"XXX: refactoring me
	let l:is_windows = has('win32')
	let l:filepath   = split(expand('%'), '/')
	let l:filename   = l:filepath[len(l:filepath)-1] . strftime(l:is_windows ? '_at_%H-%M' : '_at_%H:%M')
	let l:location   = l:dailydir . '/' . l:filename

	call writefile(getline(1, '$'), l:location)
endfunction


" make directory and set owner
function! s:mkdir_with_condition(dir)
	call mkdir(a:dir, 'p', 0755)

	if has('unix')
		let l:username  = $USER
		let l:groupname = $GROUP !=# '' ? $GROUP : $USER
		let l:command   = printf('chown -R %s:%s %s', l:username, l:groupname, a:dir)
		call system(l:command)
	endif
endfunction
