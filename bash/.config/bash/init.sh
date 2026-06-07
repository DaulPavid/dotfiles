export VISUAL=vim
export EDITOR="$VISUAL"
set -o vi

HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT='%F %T '
shopt -s histappend cmdhist
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

if [ -d "$HOME/.local/bin" ]; then
    case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) PATH="$HOME/.local/bin:$PATH";; esac
fi

for _f in ~/.config/bash/tools.sh ~/.config/bash/functions.sh; do
    [ -r "$_f" ] && . "$_f"
done
unset _f
