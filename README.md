# Vim git-flow-format

git-flow-format is a plugin for [vim-airline](https://github.com/bling/vim-airline), which formats a Git Flow branch name
in order to shorten the prefixes and take up less space in your status line.

This is best shown with a couple of examples:
```
feature/new_thing --> F:new_thing
release/v1.0.0 --> R:v1.0.0
```

## Installation

git-flow-format can be installed with [Pathogen](https://github.com/tpope/vim-pathogen) in the normal way.
Just clone this repo into your bundle directory:
```Shell
git clone https://github.com/renyard/vim-git-flow-format.git ~/.vim/bundle/vim-git-flow-format
```

You can then configure [vim-airline](https://github.com/bling/vim-airline) to use this format by adding the following line to your .vimrc:
```VimL
let g:airline#extensions#branch#format = 'Git_flow_branch_format'
```

## Customization

If you don't like the shortened prefixes provided by git-flow-format,
you can provide a dictionary of your own prefixes in the style of the default:

```VimL
let g:git_flow_prefixes = {
    \ 'master': '',
    \ 'develop': '',
    \ 'feature': 'F:',
    \ 'release': 'R:',
    \ 'hotfix': 'H:',
    \ 'support': 'S:',
    \ 'versiontag': 'V:'
\ }
```

Assigning an empty string, as in master and develop,
will result in no substitution being performed for matching branches.
