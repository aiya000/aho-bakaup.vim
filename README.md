# aho-bakaup.vim
[![Build Status](https://travis-ci.org/aiya000/aho-bakaup.vim.svg?branch=master)](https://travis-ci.org/aiya000/aho-bakaup.vim)

　aho-bakaup.vimはアホやバカのためのVimプラグインです（これはジョークです！） :cry:  
aho-bakaup.vimは執拗なほどにファイルをバックアップします！

aho-bakaup.vimは`:write`時に、保存したファイルの直前の内容を、指定のディレクトリに保存します。  
バックアップ済みファイルは、その時点での時間, 分, 秒に即したファイル名で保存されます。

example
```
~/.backup/vim_backup/2016-10-06/%home%aiya000%Repository%aho-bakaup.vim%README.md_at_11:06
```

　貴方はこれを参照することにより、VCSからすら見放された状況を打破することができます！ :+1:  
このプラグインのおかげで、私は何度救われたことか！ :smile: （まじで）


## How to install

### dein.vim

Please follow these line

```vim
call dein#add('aiya000/aho-bakaup.vim')
```

## Special option

```vim
let g:bakaup_auto_backup = 1
```

This value is 0 by default.

If this is set,
each file is saved when you execute `:write` on your vim, automatically.

More spec is available in ./doc (help for vim) .  
Please see it in your vim :smile:


## TODO
- Make document in English
- Support BakaupArchive on Windows
