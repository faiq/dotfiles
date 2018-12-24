#!/bin/bash
#set -x
#[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;}

for f in ~/dotfiles/*
do
  case $f in
    $(pwd)/install.sh)
      ;;
    $(pwd)/bin)
      ln -s "$f" "$HOME/${f##*/}"
      ;;
    *)
      ln -s "$f" "$HOME/.${f##*/}"
  esac
  #if [ "$f" != "install.sh" ]; then
  #  ln -s "$f" "$HOME/.${f##*/}"
  #fi
done
#mkdir -p ~/.vim/bundle
#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#vim +PluginInstall +qall
#source ~/.bash_profile
