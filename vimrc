set termencoding=utf-8
set background=dark
set nocompatible              " be improved, required
set backspace=indent,eol,start
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Bundle 'fatih/vim-go'
Bundle 'belltoy/vim-protobuf'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'fugitive.vim'
Plugin 'godlygeek/csapprox'
Plugin 'scrooloose/nerdtree'
Plugin 'flazz/vim-colorschemes'
Plugin 'mattn/emmet-vim'
Plugin 'elzr/vim-json'
Plugin 'kien/ctrlp.vim'
Plugin 'ConradIrwin/vim-bracketed-paste'
Plugin 'vim-scripts/Vimplate-Enhanced'
Plugin 'udalov/kotlin-vim'
Plugin 'hashivim/vim-terraform'
Plugin 'juliosueiras/vim-terraform-completion'
call vundle#end()            " required
filetype plugin indent on    " required
nnoremap ; :
syntax on
colorscheme desert
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smarttab
set ru
autocmd Filetype html setlocal ts=4 sw=4 noexpandtab
autocmd Filetype javascript  setlocal ts=2 sw=2 expandtab
autocmd Filetype bash  setlocal ts=2 sw=2 expandtab
autocmd Filetype python setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype go setlocal ts=8 sw=8 sts=0 noexpandtab
autocmd FileType make setlocal noexpandtab
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
"autocmd bufwritepost *.js silent !standard --fix %
set autoread

set autoread

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
nnoremap <C-c> <C-z>
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)


au FileType go nmap <Leader>dos <Plug>(go-doc-split)
au FileType go nmap <Leader>dov <Plug>(go-doc-vertical)
au FileType go nmap <Leader>dot <Plug>(go-doc-tab)

" Run, build, test, coverage
au FileType go nmap <Leader>r <Plug>(go-run)
au FileType go nmap <Leader>b <Plug>(go-build)
au FileType go nmap <Leader>t <Plug>(go-test)
au FileType go nmap <Leader>c <Plug>(go-coverage)

au BufNewFile,BufRead *.kt set filetype=kotlin

" nohl fast
map nh :nohl<CR>

let mapleader=","
let maplocalleader="."
let Vimplate = "~/.vim/bundle/Vimplate-Enhanced/vimplate.pl"
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
let g:NERDTreeDirArrows=0
let g:ycm_path_to_python_interpreter="/usr/bin/python3"
setlocal foldmethod=syntax
autocmd InsertEnter * let w:last_fdm=&foldmethod | setlocal foldmethod=manual
autocmd InsertLeave * let &l:foldmethod=w:last_fdm

" set spell
