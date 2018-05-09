PATH=$PATH:$HOME/.rvm/bin:$HOME/bin # Add RVM to PATH for scripting
[ -z "$PS1" ] && return # If not running interactively, don't do anything
HISTSIZE=
HISTFILESIZE=
HISTCONTROL=ignoreboth

shopt -s histappend # append to history file
shopt -s checkwinsize # ensure window size is correct

set -o vi

function EXT_COL () { echo -ne "\[\033[38;5;$1m\]"; }


USERCOL=`EXT_COL 25`
ATCOL=`EXT_COL 26`
HOSTCOL=`EXT_COL 29`
PATHCOL=`EXT_COL 115`
BRANCHCOL=`EXT_COL 216`
RETURNCOL=`EXT_COL 9`
TIMECOL=`EXT_COL 242`

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function parse_git_dirty {
        status=`git status 2> /dev/null`
        dirty=`echo -n "${status}" 2> /dev/null | grep -q "modified:" 2> /dev/null; echo "$?"`
        untracked=`echo -n "${status}" 2> /dev/null | grep -q "Untracked files" 2> /dev/null; echo "$?"`
        ahead=`echo -n "${status}" 2> /dev/null | grep -q "Your branch is ahead of" 2> /dev/null; echo "$?"`
        newfile=`echo -n "${status}" 2> /dev/null | grep -q "new file:" 2> /dev/null; echo "$?"`
        renamed=`echo -n "${status}" 2> /dev/null | grep -q "renamed:" 2> /dev/null; echo "$?"`
        bits=''
        if [ "${dirty}" == "0" ]; then
                bits="${bits}⚡"
        fi
        if [ "${untracked}" == "0" ]; then
                bits="${bits}?"
        fi
        if [ "${newfile}" == "0" ]; then
                bits="${bits}+"
        fi
        if [ "${ahead}" == "0" ]; then
                bits="${bits}*"
        fi
        if [ "${renamed}" == "0" ]; then
                bits="${bits}>"
        fi
        echo "${bits}"
}

nonzero_return() {
   RETVAL=$?
   [ $RETVAL -ne 0 ] && echo " ⏎ $RETVAL "
}

PS1="\n$TIMECOL\@ $USERCOL \u $ATCOL@ $HOSTCOL\h $PATHCOL \w $RETURNCOL\`nonzero_return\`$BRANCHCOL \`parse_git_branch\`\`parse_git_dirty\` $NC\n\\$ "

if [ -f ~/.bash_aliases ]; then
   . ~/.bash_aliases
fi

if [ -f ~/.bash_local ]; then
   . ~/.bash_local
fi

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

ulimit -n 1024
ulimit -u 1024
export EDITOR=vim
alias tmux="TERM=screen-256color-bce tmux"
alias l='ls'
alias la='ls -a'
alias sl='ls'
alias ll='ls'
alias ci='vi'
alias bi='vi'
alias gti='git'
alias gut='git'
export PATH=/usr/local/bin:$PATH
export ES_HOME=~/dev/elasticsearch/
export PATH=$ES_HOME/bin:$JAVA_HOME/bin:$PATH
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
export GOPATH=~/go
export PATH=$PATH:/$GOPATH/bin
export PATH=$PATH:$HOME/bin
export GO15VENDOREXPERIMENT=1

export PATH=$PATH:/Users/Faiq/bin

source '/Users/Faiq/lib/azure-cli/az.completion'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/Faiq/Downloads/google-cloud-sdk/path.bash.inc' ]; then source '/Users/Faiq/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/Faiq/Downloads/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/Faiq/Downloads/google-cloud-sdk/completion.bash.inc'; fi

##
# Your previous /Users/Faiq/.bash_profile file was backed up as /Users/Faiq/.bash_profile.macports-saved_2017-07-12_at_19:13:00
##

# MacPorts Installer addition on 2017-07-12_at_19:13:00: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.
export LC_CTYPE=en_US.UTF-8

#Maven bullshit
export M3_HOME="/Applications/apache-maven-3.5.3" # replace n.n.n with appropriate version
export M3=$M3_HOME/bin
export PATH=$M3:$PATH

function oshell(){
  PS1="\n$TIMECOL\@ $USERCOL \u $ATCOL@ $HOSTCOL\h $PATHCOL \w $RETURNCOL\`nonzero_return\`$BRANCHCOL \`parse_git_branch\`\`parse_git_dirty\` (oracle) $NC\n\\$ "
  source ~/bin/oracle
}

export PATH=/Users/Faiq/bin:$PATH

[[ -e "/Users/Faiq/lib/oracle-cli/lib/python3.6/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "/Users/Faiq/lib/oracle-cli/lib/python3.6/site-packages/oci_cli/bin/oci_autocomplete.sh"
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
