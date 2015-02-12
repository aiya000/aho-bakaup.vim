scriptencoding utf-8

if exists('g:loaded_bakaup')
  finish
endif
let g:loaded_bakaup = 1

" --- --- --- --- --- --- --- --- --- "


let g:bakaup_backup_dir     = get(g:, 'bakaup_backup_dir', expand('~/.backup/vim_backup'))
let g:bakaup_default_config = get(g:, 'bakaup_default_config', 0)

command! BakaupBackup call bakaup#backup_to_dir()


" --- --- --- --- --- --- --- --- --- "

if g:bakaup_default_config
	" disabled default backup
	set nobackup

	" registered auto backup
	augroup BakaupBackup
		autocmd!
		autocmd BufWritePre ?\+ silent call bakaup#backup_to_dir()
	augroup END
endif
