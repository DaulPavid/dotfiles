# dotfiles

Personal config for bash, tmux, git, and ssh.

## Usage

```
$ ./install.sh 
```

Or run the scripts individually:

```
$ ./install/packages.sh
$ ./install/extras.sh
$ ./link
```

## Tools

| Tool        | Replaces / adds        | Notes                                          |
| ----------- | ---------------------- | ---------------------------------------------- |
| `fzf`       | fuzzy finder           | powers `Ctrl-T`, `Ctrl-R`, `Alt-C` + functions |
| `ripgrep`   | `grep`                 | `rg`                                           |
| `fd`        | `find`                 | installed as `fdfind`, aliased to `fd`         |
| `bat`       | `cat`                  | installed as `batcat`, aliased to `cat`/`bat`  |
| `eza`       | `ls`                   | git-aware, used by the `ls`/`ll`/`la` aliases  |
| `zoxide`    | `cd`                   | adds `z`/`zi` smart-jump commands              |
| `git-delta` | git pager / diff       | syntax-highlighted diffs, set as git pager     |
| `jq` / `yq` | JSON / YAML processing | `yq` is the mikefarah build                    |
| `tree`      | directory listing      | also `lt` via eza                              |

## Shell aliases

| Alias    | Expands to                                | Purpose                       |
| -------- | ----------------------------------------- | ----------------------------- |
| `rm`     | `rm -i`                                   | prompt before delete          |
| `cp`     | `cp -i`                                   | prompt before overwrite       |
| `mv`     | `mv -i`                                   | prompt before overwrite       |
| `..`     | `cd ..`                                   | up one directory              |
| `...`    | `cd ../..`                                | up two directories            |
| `....`   | `cd ../../..`                             | up three directories          |
| `path`   | `echo -e ${PATH//:/\n}`                   | print `$PATH` one per line    |
| `reload` | `source ~/.bashrc`                        | reload shell config           |
| `g`      | `git`                                     | git shorthand                 |
| `gs`     | `git status -sb`                          | short status                  |
| `gd`     | `git diff`                                | diff                          |
| `ga`     | `git add`                                 | stage                         |
| `gc`     | `git commit -v`                           | commit with diff in editor    |
| `gp`     | `git push`                                | push                          |
| `gco`    | `git checkout`                            | checkout                      |
| `gl`     | `git log --oneline --graph --decorate -20`| compact recent log            |
| `ls`     | `eza --group-directories-first`           | dirs first                    |
| `ll`     | `eza -l --git ...`                        | long listing, git status      |
| `la`     | `eza -la --git ...`                       | long listing incl. hidden     |
| `lt`     | `eza --tree --level=2`                    | 2-level tree                  |
| `l`      | `eza`                                      | bare eza                      |
| `cat`    | `bat --paging=never`                      | syntax-highlighted cat        |

## Shell functions

Functions marked `(fzf)` require `fzf`. `$PROG_ROOT` defaults to `~/prog`.

| Function      | Usage                 | What it does                                            |
| ------------- | --------------------- | ------------------------------------------------------ |
| `mkcd`        | `mkcd DIR`            | create dir (with parents) and `cd` into it             |
| `extract`     | `extract FILE`        | unpack most archive formats (tar/zip/7z/rar/…)         |
| `serve`       | `serve [PORT]`        | static HTTP server in cwd (default 8000)               |
| `port`        | `port PORT`           | show what is listening on a TCP port                   |
| `yqf`         | `yqf FILE [EXPR]`     | query a YAML file (default expr `.`)                   |
| `ts`          | `ts [NAME]`           | attach/create tmux session; no arg = fzf session picker |
| `gcd` (fzf)   | `gcd`                 | fuzzy-jump into a project under `$PROG_ROOT`            |
| `tsp` (fzf)   | `tsp`                 | new tmux session rooted at a fuzzy-picked project      |
| `fkill` (fzf) | `fkill`               | pick process(es) with fzf and kill them                |
| `fco` (fzf)   | `fco`                 | fuzzy git branch checkout                               |
| `flog` (fzf)  | `flog [git-log args]` | browse git log, preview commit (delta if available)    |
| `jqf` (fzf)   | `jqf FILE.json`       | fuzzy-pick a JSON path and print its value             |

## fzf keybindings

| Keybinding | Action                                            |
| ---------- | ------------------------------------------------- |
| `Ctrl-T`   | insert fuzzy-picked file path into the command    |
| `Ctrl-R`   | fuzzy-search command history                      |
| `Alt-C`    | fuzzy-pick a directory and `cd` into it           |

## git aliases

| Alias | Expands to                          |
| ----- | ----------------------------------- |
| `a`   | `add`                               |
| `ct`  | `commit -v`                         |
| `co`  | `checkout`                          |
| `pf`  | `push --force-with-lease`           |
| `s`   | `status -sb`                        |
| `d`   | `difftool`                          |
| `lg`  | `log --oneline --graph --decorate`  |

## tmux keybindings

Prefix is remapped to **`Ctrl-a`** (press prefix, then the key). Bindings marked *repeat*
can be pressed repeatedly without re-pressing the prefix.

| Keybinding          | Action                                        |
| ------------------- | --------------------------------------------- |
| `Ctrl-a`            | (prefix) — press again to jump to last window |
| `a`                 | send a literal `Ctrl-a`                        |
| `r`                 | reload `~/.tmux.conf`                          |
| `v`                 | split pane horizontally (keeps cwd)           |
| `b`                 | split pane vertically (keeps cwd)             |
| `c`                 | new window (keeps cwd)                         |
| `h` `j` `k` `l`     | move to pane left / down / up / right         |
| `>` / `<`           | swap pane forward / backward                  |
| `H` `J` `K` `L`     | resize pane (*repeat*)                         |
| `Ctrl-h` / `Ctrl-l` | previous / next window (*repeat*)             |
| `Tab`               | last window                                    |
| `Ctrl-f`            | find & switch to a session by name            |
| `p`                 | paste buffer                                   |

Copy mode uses vi keys: `v` begins selection, `y`/`Enter` copy. Mouse is enabled,
and the clipboard is shared over SSH via OSC 52 (no `xclip` needed).
