scriptencoding utf-8

if exists('g:loaded_bakaup')
  finish
endif
let g:loaded_bakaup = 1

"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"
" Private field

let g:bakaup_private = {}

" Save &backup for restore when bakaup disabled
let g:bakaup_private['default_backup'] = &backup

"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"
" Global field


let g:bakaup_backup_dir  = get(g:, 'bakaup_backup_dir', expand('~/.backup/vim_backup'))
let g:bakaup_auto_backup = get(g:, 'bakaup_auto_backup', 0)

command! BakaupBackupExecute  call bakaup#backup_to_dir()
command! BakaupEnable         call bakaup#enable_auto_backup()
command! BakaupDisable        call bakaup#disable_auto_backup()


" --- --- --- --- --- --- --- --- --- "

if g:bakaup_auto_backup
	BakaupEnable
endif
