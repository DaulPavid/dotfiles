_BAT=$(command -v batcat || command -v bat || true)
_FD=$(command -v fdfind || command -v fd || true)

[ -n "$_BAT" ] && ! command -v bat >/dev/null 2>&1 && alias bat="$_BAT"
[ -n "$_FD" ]  && ! command -v fd  >/dev/null 2>&1 && alias fd="$_FD"

if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first'
    alias ll='eza -l --git --group-directories-first'
    alias la='eza -la --git --group-directories-first'
    alias lt='eza --tree --level=2'
    alias l='eza'
fi

if [ -n "$_BAT" ]; then
    alias cat="$_BAT --paging=never"
    export BAT_THEME="OneHalfDark"
    export MANPAGER="sh -c 'col -bx | $_BAT -l man -p'"
fi

if command -v fzf >/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"
    if [ -n "$_FD" ]; then
        export FZF_DEFAULT_COMMAND="$_FD --type f --hidden --follow --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="$_FD --type d --hidden --follow --exclude .git"
    fi
    [ -n "$TMUX" ] && export FZF_TMUX_OPTS="-p 80%,60%"
    for _p in /usr/share/doc/fzf/examples/key-bindings.bash \
              /usr/share/fzf/key-bindings.bash \
              ~/.fzf/shell/key-bindings.bash; do
        [ -r "$_p" ] && . "$_p" && break
    done
    for _p in /usr/share/doc/fzf/examples/completion.bash \
              /usr/share/fzf/completion.bash \
              ~/.fzf/shell/completion.bash; do
        [ -r "$_p" ] && . "$_p" && break
    done
    unset _p
fi

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)"
