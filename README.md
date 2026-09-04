# dotfiles

Config files, one branch per machine.

| Branch  | Machine                                         |
|---------|-------------------------------------------------|
| `macos` | macOS `~/.config` — kitty, tmux, nvim, themes   |
| `main`  | Ubuntu / Hyprland — hypr, rofi, cava, waybar    |

The two branches share no history: they are different machines that happen
to live in the same repo.

---

## macOS branch

Tracked in place — `~/.config` *is* the working tree. No symlinks, no stow.

| Path        | What                                       |
|-------------|--------------------------------------------|
| `nvim/`     | Neovim (lua config + plugin lockfile)      |
| `kitty/`    | Kitty terminal                             |
| `tmux/`     | tmux                                       |
| `themes/`   | Shared colorschemes + `theme-set` switcher |
| `btop/`     | btop                                       |
| `neofetch/` | neofetch                                   |
| `openlogi/` | openlogi                                   |

### Install on a new Mac

```sh
git clone -b macos git@github.com:TristanDaffe/dotfiles.git ~/.config
```

If `~/.config` already exists:

```sh
git clone --bare -b macos git@github.com:TristanDaffe/dotfiles.git /tmp/config.git
git --git-dir=/tmp/config.git --work-tree="$HOME/.config" checkout -f macos
mv /tmp/config.git "$HOME/.config/.git"
git -C ~/.config config --unset core.bare
```

### What is not tracked

`.gitignore` denies everything by default and allow-lists the directories
above. Deliberately excluded: `filezilla/` (saved server credentials),
`github-copilot/` (auth tokens), `raycast/` (bulky extensions), plus lock
files, backups, `.DS_Store` and `themes/current`.

Adding a new tool? Add `!toolname/` to `.gitignore`.
