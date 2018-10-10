scriptencoding utf-8

if exists('g:loaded_bakaup')
  finish
endif
let g:loaded_bakaup = 1

"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"
" Global field

let g:bakaup_backup_dir  = get(g:, 'bakaup_backup_dir', expand('~/vim_bakaup'))
let g:bakaup_auto_backup = get(g:, 'bakaup_auto_backup', 0)

command! BakaupBackupExecute  call bakaup#backup_to_dir()
command! BakaupEnable         call bakaup#enable_auto_backup()
command! BakaupDisable        call bakaup#disable_auto_backup()
command! BakaupArchiveBackups call bakaup#archive_backups()

command! -nargs=1 -complete=dir BakaupSetBackupDir call bakaup#set_bakaup_dir(<q-args>)

command! BakaupExplore        call bakaup#explore()
command! BakaupTexplore       call bakaup#explore('tab')
command! BakaupVexplore       call bakaup#explore('vertical')
command! BakaupSexplore       call bakaup#explore('horizon')

"#-=- -=- -=- -=- -=- -=- -=- -=- -=-#"
" Private field

" Save &backup for restore when bakaup disabled
let g:bakaup#default_backup = &backup

" A directory for :BakaupArchiveBackups
let g:bakaup#archive_dir = g:bakaup_backup_dir . '/archive'

" --- --- --- --- --- --- --- --- --- "

if g:bakaup_auto_backup
    BakaupEnable
    if !isdirectory(g:bakaup_backup_dir)
        call mkdir(g:bakaup_backup_dir, 'p', 0700)
    endif
    if !isdirectory(g:bakaup#archive_dir)
        call mkdir(g:bakaup#archive_dir, 'p', 0700)
    endif
endif
