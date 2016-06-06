#!/bin/bash
for f in ~/dotfiles/*
do
    ln -s "$f" "$HOME/.${f##*/}"
done
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
