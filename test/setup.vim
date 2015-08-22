" Used by some test's Before All
function! PrepareBakaupDirectory()
	let g:bakaup_backup_dir = '/tmp/bakaup_vim_test_dir'
	if !isdirectory(g:bakaup_backup_dir)
		call mkdir(g:bakaup_backup_dir, 'p', 0700)
	endif

	let g:bakaup#archive_dir = g:bakaup_backup_dir . '/archive'
	if !isdirectory(g:bakaup#archive_dir)
		call mkdir(g:bakaup#archive_dir, 'p', 0700)
	endif
endfunction

" Used by some test's After All
function! DestructBakaupDirectory()
	call RemoveFile(g:bakaup_backup_dir)
endfunction

function! GetFiles(dir)
	let l:files_str = glob(a:dir . '/*')
	let l:files     = split(l:files_str, '\n')
	return l:files
endfunction

function! RemoveFile(path)
	"TODO: compatible to windows
	call system('rm -rf ' . a:path)
endfunction
