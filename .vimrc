set termencoding=utf-8
set background=dark
set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'fugitive.vim'
Plugin 'godlygeek/csapprox'
Plugin 'scrooloose/nerdtree'
Plugin 'flazz/vim-colorschemes'
Plugin 'mattn/emmet-vim' 
Plugin 'elzr/vim-json'
Plugin 'fatih/vim-go'
Plugin 'kien/ctrlp.vim'
Plugin 'nvie/vim-flake8'
call vundle#end()            " required
filetype plugin indent on    " required
nnoremap ; :
syntax on
autocmd BufWritePost *.py call Flake8()
colorscheme desert
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript  setlocal ts=2 sw=2 expandtab
autocmd Filetype python setlocal ts=4 sw=4 sts=0 expandtab
set t_Co=256
let &t_Co=256
