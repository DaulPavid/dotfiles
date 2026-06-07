PROG_ROOT="${PROG_ROOT:-$HOME/prog}"

# mkcd DIR -- create dir (with parents) and cd into it
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# extract FILE -- unpack most archive formats
extract() {
    local f="$1"
    [ -f "$f" ] || { echo "extract: '$f' is not a file" >&2; return 1; }
    case "$f" in
        *.tar.bz2|*.tbz2) tar xjf "$f" ;;
        *.tar.gz|*.tgz)   tar xzf "$f" ;;
        *.tar.xz|*.txz)   tar xJf "$f" ;;
        *.tar.zst)        tar --zstd -xf "$f" ;;
        *.tar)            tar xf  "$f" ;;
        *.bz2)            bunzip2 "$f" ;;
        *.gz)             gunzip  "$f" ;;
        *.xz)             unxz    "$f" ;;
        *.zip)            unzip   "$f" ;;
        *.7z)             7z x    "$f" ;;
        *.rar)            unrar x "$f" ;;
        *.Z)              uncompress "$f" ;;
        *) echo "extract: don't know how to unpack '$f'" >&2; return 1 ;;
    esac
}

# serve [PORT] -- static http server in cwd (default 8000)
serve() { python3 -m http.server "${1:-8000}"; }

# port PORT -- show what is listening on a TCP port
port() { ss -tulpn "sport = :${1:?usage: port PORT}" 2>/dev/null || lsof -i :"$1"; }

if command -v fzf >/dev/null 2>&1; then
    # gcd -- fuzzy-jump into a project under $PROG_ROOT
    gcd() {
        local dir
        dir=$(find "$PROG_ROOT" -mindepth 1 -maxdepth 3 -type d 2>/dev/null \
              | fzf --prompt="project> ") && cd "$dir"
    }

    # fkill -- pick process(es) with fzf and kill them
    fkill() {
        local pids
        pids=$(ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | sed 1d \
               | fzf -m --prompt="kill> " | awk '{print $1}')
        [ -n "$pids" ] && echo "$pids" | xargs -r kill
    }

    # fco -- fuzzy git branch checkout
    fco() {
        local br
        br=$(git branch --all --color=never | sed 's/^[* ] //;s#remotes/[^/]*/##' \
             | sort -u | fzf --prompt="checkout> ") && git checkout "$br"
    }

    # flog -- browse git log, preview the commit (delta if available)
    flog() {
        local pager="less -R"
        command -v delta >/dev/null 2>&1 && pager="delta"
        git log --oneline --color=always "$@" \
          | fzf --ansi --no-sort --prompt="log> " \
                --preview "git show --color=always {1} | $pager" \
          | awk '{print $1}'
    }

    # jqf FILE -- fuzzy-pick a JSON path and print its value
    jqf() {
        local file="${1:?usage: jqf FILE.json}" sel
        sel=$(jq -r '
            paths(scalars) as $p | $p
            | map(if type=="number" then "["+tostring+"]" else "."+tostring end)
            | join("")' "$file" 2>/dev/null \
            | fzf --prompt="jq> " --preview "jq -C '{}' '$file'") || return
        echo "$sel"
        jq "$sel" "$file"
    }
fi

# yqf FILE [EXPR] -- query a YAML file (needs mikefarah yq)
yqf() {
    command -v yq >/dev/null 2>&1 || { echo "yqf: yq not installed" >&2; return 1; }
    yq "${2:-.}" "${1:?usage: yqf FILE.yaml [expr]}"
}

# ts [NAME] -- attach/create session NAME; no arg = fzf session picker
ts() {
    if [ -n "$1" ]; then
        tmux new-session -A -s "$1"
    elif command -v fzf >/dev/null 2>&1; then
        local s
        s=$(tmux list-sessions -F '#S' 2>/dev/null | fzf --prompt="tmux> ") \
            && tmux attach -t "$s"
    else
        tmux attach || tmux new-session
    fi
}

# tsp -- new tmux session rooted at an fzf-picked project under $PROG_ROOT
tsp() {
    command -v fzf >/dev/null 2>&1 || { echo "tsp: needs fzf" >&2; return 1; }
    local dir name
    dir=$(find "$PROG_ROOT" -mindepth 1 -maxdepth 3 -type d 2>/dev/null \
          | fzf --prompt="new session in> ") || return
    name=$(basename "$dir" | tr . _)
    tmux new-session -A -s "$name" -c "$dir"
}
