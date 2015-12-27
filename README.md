# aho-bakaup.vim
[![Build Status](https://travis-ci.org/aiya000/aho-bakaup.vim.svg?branch=master)](https://travis-ci.org/aiya000/aho-bakaup.vim)

aho-bakaup.vim is auto backuper for vim .  
auto backup to directory when executed :write  

BakaupArchive command supported \*NIX OS only .  

あなたはこれを入れるだけで、  
Vimで編集した多くのファイルのバックアップを貯めておくことができます。  

バックアップを貯めることにより、何年の何日の何時何分かにあなたがバックアップした  
ファイルの内容を得ることができます。  

また、バックアップにはundofileと同じくファイル名にディレクトリ情報が保存されます。  

バックアップはデフォルトでは、ファイル書き込み時に行われるようになっています。  


## Introduce
You only write to your vimrc.  
```
NeoBundle 'aiya000/aho-bakaup.vim'
let g:bakaup_auto_backup = 1
```

If it set, auto backup file to default backup directory.

- - - - -

author: aiya000  
since:  2015-02-12  
