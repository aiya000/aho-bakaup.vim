# aho-bakaup.vim
[![Build Status](https://travis-ci.org/aiya000/aho-bakaup.vim.svg?branch=master)](https://travis-ci.org/aiya000/aho-bakaup.vim)

aho-bakaup.vimはアホやバカのためのVimプラグインです。  
aho-bakaup.vimは`:write`時に、保存したファイルの直前の内容を、指定のディレクトリに保存します。  
バックアップ済みファイルは、その時点での時間, 分, 秒に即したファイル名で保存されます。

example
```
~/.backup/vim_backup/2016-10-06/%home%aiya000%Repository%aho-bakaup.vim%README.md_at_11:06
```

貴方はこれを参照することにより、VCSからすら見放された状況を打破することができます！


## Introduce
The example for dein.vim
```
call dein#add('aiya000/aho-bakaup.vim')
let g:bakaup_auto_backup = 1
```

If it set, auto backup file to default backup directory.


## TODO
- Support BakaupArchive on Windows


- - - - -

- author: aiya000
- since:  2015-02-12
