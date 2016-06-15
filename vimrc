set termencoding=utf-8
set background=dark
set nocompatible              " be iMproved, required

filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Bundle 'fatih/vim-go'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'fugitive.vim'
Plugin 'godlygeek/csapprox'
Plugin 'scrooloose/nerdtree'
Plugin 'flazz/vim-colorschemes'
Plugin 'mattn/emmet-vim'
Plugin 'elzr/vim-json'
Plugin 'kien/ctrlp.vim'
Plugin 'nvie/vim-flake8'
Plugin 'ConradIrwin/vim-bracketed-paste'
call vundle#end()            " required
filetype plugin indent on    " required
nnoremap ; :
syntax on
colorscheme desert
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smarttab
set ru
autocmd BufWritePost *.py call Flake8()
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript  setlocal ts=2 sw=2 expandtab
autocmd Filetype python setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype go setlocal ts=8 sw=8 sts=0 noexpandtab
set t_Co=256
let &t_Co=256
let g:go_fmt_command = "goimports"
"white space detection
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
set hlsearch
set ignorecase
set nu
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
