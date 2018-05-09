#!/bin/bash
set -x
[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;}

for f in ~/dotfiles/*
do
  if [ "$f" != `basename "$0"` ]; then
    ln -s "$f" "$HOME/.${f##*/}"
  fi
done
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
source ~/.bash_profile
