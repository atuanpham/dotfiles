export PROMPT="%~ %# "
export PATH=$PATH:/usr/local/go/bin

if [ "$COLORTERM" = "gnome-terminal" ]; then
    export TERM=xterm-256color
fi

# Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ll="ls -al"
