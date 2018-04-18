# :muscle: aho-bakaup.vim :muscle:
[![Build Status](https://travis-ci.org/aiya000/aho-bakaup.vim.svg?branch=master)](https://travis-ci.org/aiya000/aho-bakaup.vim)

A strongly `'backup'` of Vim for each your saving!

# :diamond_shape_with_a_dot_inside: What is this? :diamond_shape_with_a_dot_inside:
This backs up a file when you `:write` the file.

For example, below file is saved when you `:write` /home/you/todo.md at 2016-10-06 11:06 :dog2:

```
~/.backup/vim_backup/2016-10-06/%home%you%todo.md_at_11:06
```

# :gift: How to install :gift:
## With dein.vim
Please follow below line.

```vim
call dein#add('aiya000/aho-bakaup.vim')
```

Or follow below line if you use toml

```toml
[[plugins]]
repo   = 'aiya000/aho-bakaup.vim'
```

And if you load toml lazily, you can use below lines.

```toml
[[plugins]]
repo   = 'aiya000/aho-bakaup.vim'
on_cmd = [
    'BakaupBackupExecute',
    'BakaupEnable',
    'BakaupDisable',
    'BakaupArchiveBackups',
    'BakaupSetBackupDir',
    'BakaupExplore',
    'BakaupTexplore',
    'BakaupVexplore',
    'BakaupSexplore',
]
```

# :thinking: How to use this :thinking:

```vim
let g:bakaup_auto_backup = 1
```

This value is 0 by default.

aho-bakaup.vim is not enabled by default.  
Above line enables aho-bakaup.vim!

More specs are availabled in ./doc (`:help bakaup.vim`) :dog:
