# VIM

# Add VIM Default Config
vim ~/.vimrc # lines started with " is comment in this file


# VIM Spell Checking
# enable spellchecking: 
:set spell #or :set spell spelllang=en_us
# disable:
:set nospell

# fix wrong spelling
z=

# user dictionary (create, add or delete custom words)
:set spellfile=~/.vim/user-dict.utf-8.add # !!!MUST ends with ${encoding}.add
# add word into user dictionary
zg
# remove ...
zw


# VIM Completion
# normal word completion:
ctrl+n
# file path completion
ctrl+x ctrl+f


# VIM Imporved Completion (YouCompleteMe)

# 0. Required environments:
## VIM version at least: 7.4.1578
## Python2 or Python3

# 1. Install VIM plugin managaer(Vundle)
## git clone into ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
## Config vbundle into ~./vimrc
## Details in: https://github.com/VundleVim/Vundle.vim#quick-start
## PREPEND text follow into ~/.vimrc
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
" Plugin ...
" ... Your plugins
call vundle#end()
filetype plugin indent on
## For fish shell user, add:
:set shell=/bin/bash

# 2. Install YouCompleteMe (For UBUNTU)
## Other OS reference:
https://github.com/Valloric/YouCompleteMe#installation

## git clone into ~/.vim/bundle
cd ~/.vim/bundle/
git clone --recurse-submodules https://github.com/Valloric/YouCompleteMe
## you can check git submodules in YouCompleteMe folder:
cd YouCompleteMe; git submodule update --init --recursive

## Install denpendencies (For Ubuntu14.04: replace cmake to cmake3)
sudo apt install python-dev python3-dev build-essential cmake
## (Optional) If you want completion for c-languages
sudo apt install llvm-3.9 clang-3.9 libclang-3.9-dev libboost-all-dev

## Complie YouCompleteMe
cd ~/.vim/bundle/YouCompleteMe
./install.py # --clang-completer --js-completer --go-completer ...
# more install.py options: https://github.com/Valloric/YouCompleteMe#installation

## Enablele YouCompleteMe in ~/.vimrc
vim ~/.vimrc
# Add follow line after Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'

## (Optional) Semantic support For C/Cpp developer:
cp ~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py ~/.vim/
vim ~/.vimrc
# insert follow config text after Vbundle init:
let g:ycm_server_python_interpreter='/usr/bin/python'
let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'

## (Optional) Semantic support For javascript developer:
# add .tern-project file into your project root path, example content:
{
  "libs": [ "browser", "jquery" ],
  "loadEagerly": [ "common.js" ],
  "plugins": { "node": {} }
}
