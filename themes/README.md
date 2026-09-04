# themes

One selection, three apps. `current` is a symlink to a theme directory; kitty,
tmux and nvim each read their own file out of it, so switching the symlink
retheme everything.

    themes/
      current -> rose-pine      # the only piece of state
      theme-set                 # switch + live-reload
      tmux-git                  # shared: prints the git branch, no colors
      rose-pine/
        kitty.conf              # palette (upstream, authoritative)
        tmux.conf               # @thm_* palette + per-theme overrides only
        nvim.lua                # sets colorscheme, returns lualine theme name
      duskfox/
      tokyonight-moon/
      dracula/

## Usage

    theme-set                # interactive picker
    theme-set duskfox        # switch directly
    theme-set -l             # just the names, one per line
    theme-set --help

`theme-set` with no argument opens a picker, starting on the current theme:

| key | action |
|-----|--------|
| `j` / `Down` | next (wraps) |
| `k` / `Up` | previous (wraps) |
| `g` / `G` | first / last |
| `1`-`9` | jump to that entry |
| `Enter` | select |
| `q` / `Esc` | cancel, change nothing |

If fzf is installed it is used instead, adding fuzzy search and a live palette
preview pane. Otherwise the built-in navigator runs — no dependencies.

A third fallback, a plain numbered menu, is used when `/dev/tty` is unreadable.

The picker only appears when stdin and stderr are terminals, so
`theme-set | grep ...` and any non-interactive caller still get a plain listing
rather than hanging on a prompt.

`theme-set --preview <name>` prints a theme's palette as colored swatches. It
exists for the fzf preview pane but is useful on its own.

## How each app is wired

| app   | file                    | line                                          |
|-------|-------------------------|-----------------------------------------------|
| kitty | `~/.config/kitty/kitty.conf` | `include ../themes/current/kitty.conf`   |
| tmux  | `~/.config/tmux/tmux.conf` | `source-file ~/.config/themes/current/tmux.conf` (last line) |
| nvim  | `~/.config/nvim/lua/theme.lua` | `dofile` of `current/nvim.lua`, called from `plugins.lua` |

kitty's include is relative to the directory holding `kitty.conf`, and is placed
last in the file so theme colors win over anything above it.

## Reload behaviour

`theme-set` repoints the symlink, then tries to reload each running app:

- **kitty** — `kitty @ set-colors`, which needs `allow_remote_control yes` in
  `kitty.conf`. Without it the theme applies on next launch instead.
- **tmux** — `source-file` + `refresh-client`. Works always.
- **nvim** — sends `:ThemeReload` to every listening instance over its socket.
  Instances started without `--listen` pick the theme up on next start.

## The tmux bar

### Where the bar is defined

Layout and behaviour are **defaults** in `~/.config/tmux/tmux.conf`. Colors come
from `@thm_*` tmux user options that each theme sets. The main config sources
the theme as its **last line**, so a theme can override any default:

    ~/.config/tmux/tmux.conf        defaults: layout, formats, position
      └── sources at the end ──>    themes/current/tmux.conf   palette + overrides

To change the bar for **every** theme, edit `~/.config/tmux/tmux.conf`.
To change it for **one** theme, add the line to that theme's `tmux.conf`:

    set -g status-position bottom     # this theme only

Because the main config is re-sourced on every switch, an override is undone
when you move to a theme that does not set it. `theme-set` sources the main
config, never the theme file directly, for exactly this reason.

**The bar background is transparent by default** (`@thm_bar_bg "default"`),
so it inherits the terminal background and blends into kitty. A theme can opt
out with `set -g @thm_bar_bg "#2d2a45"`.

**Style vs colour options.** tmux format-expands *style* options
(`status-style`, `pane-border-style`, …) but **not** *colour* options.
`display-panes-colour`, `display-panes-active-colour` and `clock-mode-colour`
reject `#{@thm_*}` with `bad colour`, so those three live in each theme file
with literal hexes. If you add a colour option, expect the same.


Designed against five principles from *A UX Expert Fixes My Tmux*: put the bar
where the eye already is, mark the active window subtly, use icons to carry
meaning, keep colors calm, and show information only when it is relevant.

     dev │  1  nvim ·  2 shell │  main  14:32
     \___/   \____________________/   \___________/
    session          windows           relevancy + git + clock

**Position.** `status-position top`. nvim's lualine occupies the bottom, so
tmux sits above the context as a roof rather than stacking two bars together.

**Active window.** A star plus a one-step background lift — deliberately not a
saturated fill. Strong color reads well in a screenshot and gets tiring over a
full working day, so the emphasis is shape (the star) more than hue.

**The terminal icon** appears only on windows you have *not* renamed. tmux
auto-names those after the running process, so the format compares
`window_name` against `pane_current_command`; set a real title and the icon
gives way to it. This is the nudge to name your windows.

**Relevancy.** `tmux-alert` prints nothing unless something needs attention, so
the segment and its spacing disappear together. It ships warning on low battery
while discharging; swap the body for a meeting countdown, CI state, or anything
else. The contract is only: print a short string, or print nothing.

`tmux-git` follows the same rule — no branch outside a repo. Detached HEAD
shows a short sha.

### Editing gotchas

- **Nerd font glyphs get stripped by some editors and tools.** These files use
  U+F005 (star), U+F120 (terminal) and U+F243 (battery) from the Private Use
  Area. If an icon silently vanishes, `#{?cond,,}` collapses to empty on both
  branches and fails *silently*. Check with:
  `python3 -c "import pathlib;print(pathlib.Path('dracula/tmux.conf').read_text().count(chr(0xf005)))"`
- **`#()` is asynchronous.** The bar paints once with those segments empty, then
  fills on the next `status-interval` (5s). Not a bug, and there is no way to
  force a synchronous first paint.
- **`display-message -p '#{E:status-right}'` does not run `#()` jobs**, so it
  cannot verify the git or alert segments. Only a real render shows them.
- `#{W:...}` *does* evaluate window formats, which is the way to check the
  active/inactive and icon conditionals without attaching.

Note the git branch also appears in lualine inside nvim. Deliberate: the tmux
bar serves shell panes, lualine serves nvim.

## Adding a theme

    mkdir themes/<name>

Drop in three files. For `kitty.conf`, most themes publish a kitty palette
upstream — use it rather than transcribing hexes. For `tmux.conf`, copy an
existing one and swap the six colors in its header comment. For `nvim.lua`,
configure the colorscheme plugin, `vim.cmd.colorscheme(...)`, and `return` the
lualine theme name. Add the plugin to `nvim/lua/plugins.lua` if it's new.

## Adding an app

Give each theme directory one more file and have the app read it out of
`current/`. `btop` (`~/.config/btop`) takes `.theme` files and is the obvious
next one.
