export PROMPT="%~ %# "

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
