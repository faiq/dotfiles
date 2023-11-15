#!/bin/bash
#[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;}
function make_link_if_needed () {
  local DIR=$1
  f=$2
  echo "i am making link if needed ${DIR} ${f}"
  DIR=${DIR#"${HOME}/dotfiles/"}
  echo "new dir $DIR"
    if [ ! -f "${HOME}/.${DIR}${f##*/}" ]; then
      echo "running ln -s ${HOME}/dotfiles/${DIR}${f} ${HOME}/.${DIR}${f##*/}"
      ln -s ${HOME}/dotfiles/${DIR}${f} ${HOME}/.${DIR}${f##*/}
    fi
}

function make_links() {
  local DIR=$1
  echo "this is DIR ${DIR} and i see this $(ls ${DIR}/)"
  for f in $(ls ${DIR}/)
  do
    echo "this is f: ${f} and full f ${DIR}${f}"
    if [ -f "${DIR}${f}" ]; then
      make_link_if_needed $DIR $f
    fi
    if [ -d "${DIR}${f}" ]; then
      echo "handling directory ${f}"
  	  n=${f##*/}
      if [ "${n}" = "bin" ]; then
        echo "skipping bin"
        continue
      else
        if [ "${DIR}" = "${HOME}/dotfiles/" ]; then
          mkdir -p ${HOME}/.$n
        fi
        echo "calling with ${DIR}$n"
        make_links ${DIR}$n/
      fi
    fi
  done
}

sudo apt install neovim
make_links "${HOME}/dotfiles/"
source ~/.bash_profile
