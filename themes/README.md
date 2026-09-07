# themes

One selection, three apps. `current` is a symlink to a theme directory; kitty,
tmux and nvim each read their own file out of it, so switching the symlink
retheme everything.

Bar SHAPE is a second, independent axis: `current-bar` selects the tmux bar
layout, and every bar works with every theme because bars reference only the
`@thm_*` colours a theme sets.

Palettes and bars each live in their own directory, one level down, so neither
list can pick up the other. Anything added beside them -- a script, a README --
stays out of both pickers.

    themes/
      current     -> palettes/rose-pine   # colour  (theme-set)
      current-bar -> bars/slant           # shape   (bar-set)
      theme-set                 # switch colour + live-reload
      bar-set                   # switch shape  + live-reload
      p10k-colors.zsh           # prompt segment colours, one file for every theme
      tmux-git                  # shared: prints the git branch, no colors
      tmux-alert                # shared: prints only when it matters
      palettes/                 # COLOUR
        rose-pine/
          kitty.conf            # palette (upstream, authoritative)
          tmux.conf             # @thm_* palette + per-theme overrides only
          nvim.lua              # sets colorscheme, returns lualine theme name
          p10k.zsh              # _thm_<role>, _thm_ansi0-15, _thm_dark/light/ok
        duskfox/
        tokyonight-moon/
        dracula/
        catppuccin-mocha/
      bars/                     # SHAPE: tmux bar + zsh prompt, together
        minimal/{tmux.conf,p10k.zsh}   # no powerline: flat bar, lean prompt
        classic/{tmux.conf,p10k.zsh}   # solid fills, hard arrows
        slant/{tmux.conf,p10k.zsh}     # slanted cuts
        capsule/{tmux.conf,p10k.zsh}   # rounded pills / rounded prompt caps

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
| zsh   | `~/.zshrc` | `source ~/.config/zsh/powerline.zsh`, after `~/.p10k.zsh` |
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

## Bar layouts

Colour and shape are independent. `theme-set` changes colour, `bar-set`
changes shape, and the twelve combinations all work:

    bar-set                  # interactive picker
    bar-set capsule          # switch directly
    bar-set -l               # just the names
    bar-set --preview slant  # what it looks like, in words

Same picker keys as `theme-set`, same fzf-if-installed behaviour.

| bar | look |
|-----|------|
| `minimal` | today's bar: transparent, muted, a `│` between zones |
| `classic` | solid filled zones, hard `` arrows, colour carries the structure |
| `slant` | slanted `` transitions, only the active window filled |
| `capsule` | rounded ` ` pills floating on a transparent bar |

`minimal` contains **no settings at all**. The defaults in `tmux/tmux.conf`
already are that bar, so the file only exists to give `bar-set minimal`
something to point at.

### Sourcing order

`tmux/tmux.conf` sources the bar, then the theme:

    tmux/tmux.conf              defaults: layout, formats, position
      └─> themes/current-bar/tmux.conf    shape   (overrides the formats)
          └─> themes/current/tmux.conf    colour  (overrides anything)

The theme stays last, so a per-theme override still wins over the bar — the
contract documented above is unchanged. Colour references inside a bar are
`#{@thm_*}` format strings, expanded at *render* time, not at source time, so
a bar never needs to know which theme is loaded.

Both switchers re-source `tmux/tmux.conf`, never a leaf file directly, so an
override from the bar or theme you just left is properly undone.

### The zsh prompt

`bar-set` styles the Powerlevel10k prompt with the same geometry it gives the
tmux bar, so the prompt and the bar cut at the same angle. Two files, the same
colour/shape split as everywhere else:

| file | role |
|------|------|
| `themes/palettes/<name>/p10k.zsh` | PALETTE — `_thm_<role>`, `_thm_ansi0-15`, and the derived `_thm_dark`/`_thm_light`/`_thm_ok` |
| `themes/p10k-colors.zsh` | COLOUR — the segment scheme, one file for every theme |
| `themes/bars/<name>/p10k.zsh` | SHAPE — separators and caps only |

### Prompt colours

One file, `themes/p10k-colors.zsh`, written against the `_thm_*` variables the
selected palette sets — so it is not theme-specific and there is nothing to
regenerate.

**Why it is small.** 190 of the wizard's 204 colours are terminal indices 0-15,
which kitty repaints from the theme; those already follow `theme-set` on their
own. Only 11 use indices 16-255, which are fixed and can never follow a theme —
and three of those are the directory segment. So the file has two jobs: apply
the scheme below, and rescue that stuck handful.

Anything **not** named in it keeps the wizard's own colour, which degrades
softly: an index 0-15 still tracks the theme through kitty, it just will not be
in the scheme. Add a line to bring a segment in.

**The scheme** is transcribed from
[tolkonepiu/catppuccin-powerlevel10k-themes](https://github.com/tolkonepiu/catppuccin-powerlevel10k-themes)
(`.p10k-rainbow-catppuccin-mocha.zsh`), which does three things the wizard does
not: fills segments from the theme's own accents rather than terminal indices,
uses **one dark foreground everywhere**, and gives the prompt a dark surface
background instead of leaving it black.

| catppuccin | here | used for |
|---|---|---|
| crust | `_thm_dark` | the foreground on every filled segment |
| surface0 | `_thm_surface` | global background |
| lavender | `_thm_ansi12` | directory |
| mauve | `_thm_accent` | VCS clean |
| peach | `_thm_ansi11` | VCS modified |
| pink | `_thm_ansi13` | VCS untracked, clock |
| maroon | `_thm_ansi9` | VCS conflicted, errors |
| yellow | `_thm_ansi3` | VCS loading, jobs, direnv |
| green | `_thm_ok` | status ok |
| subtext1 | `_thm_ansi7` | command execution time |
| text | `_thm_text` | OS icon |
| sky / teal | `_thm_ansi14` / `_thm_ansi6` | python / node |

Three roles are **derived** and live in each palette rather than in the shared
file, because they cannot be expressed as a fixed ANSI index:

- `_thm_dark` — the theme's Crust equivalent, its darkest colour
- `_thm_light` — for the few segments sitting on a *dark* background, where
  dark-on-dark would be invisible (`BATTERY`, `VI_MODE`)
- `_thm_ok` — normally the theme's green, but rose-pine's green is a dark teal
  that measures 3.4:1 behind `_thm_dark`, so that palette falls back to its
  lightest positive hue

Worst contrast across the 27 filled segments: 7.08 catppuccin, 5.80 dracula,
6.31 duskfox, 6.07 rose-pine, 5.04 tokyonight.

### Bar styles and colour

All four bars use the same colours — colour is the theme's job, shape is the
bar's. `minimal` is the one that has to do colour work, because it removes the
backgrounds: a rainbow config carries each segment's hue in its *background*
and pairs it with a dark foreground (56 segments in the current config use
`fg=ansi0`). Dropping the background alone would leave near-black text on the
terminal background. So `minimal` moves the hue to the text instead — the old
background becomes the new foreground — which is exactly what a lean prompt
does. It walks `$parameters` rather than naming segments, so a future
`p10k configure` that adds segments is handled without editing anything.

`~/.config/zsh/powerline.zsh` sources the palette, then the generated colours,
then the geometry, and `~/.zshrc` sources *that* **after** `~/.p10k.zsh` — the wizard's 90 KB config
still defines which segments exist and how they behave; these two files only
restyle them. Run `p10k configure` whenever you like: it rewrites `~/.p10k.zsh`
and the theming still lands on top.

| bar | prompt |
|-----|--------|
| `minimal` | lean: no filled blocks, no separator glyphs, foreground colour only |
| `classic` | solid `` arrows |
| `slant` | slanted `` cuts, the same glyphs as the slant tmux bar |
| `capsule` | rounded `` `` caps at both ends of each prompt line |

**Open shells retheme themselves at their next prompt.** Nothing to run.

A switcher runs in its own process and cannot touch the variables of a shell
that is already running — no script can. Signalling is not an option either:
zsh's default action for `SIGUSR1` is to **terminate**, so the usual
`pkill -USR1 zsh` would kill any zsh without a trap installed, including
non-interactive ones running scripts.

So each shell checks for itself. `_powerline_precmd` compares the resolved
targets of the two symlinks against what it last loaded, and re-sources only
when they have moved. `${x:A}` resolves a symlink as a parameter expansion, so
an unchanged prompt costs one string comparison and no fork.

The hook is **prepended** to `precmd_functions`, not appended: p10k registers
its own precmd when oh-my-zsh loads the theme, which happens before `~/.zshrc`
reaches this file. Appending would run us after p10k, and `p10k reload` would
land one prompt late.

`powerline-reload` remains as the manual escape hatch — it forces a reload even
when the symlinks have *not* moved, which is what you want after editing a
palette or bar file in place.

**`p10k reload` on its own is never enough.** It only sets
`_p9k__force_must_init=1` (`internal/p10k.zsh:9339`), re-running p10k's init
against the `POWERLEVEL9K_*` values *already in the shell*. It never re-reads a
file, so on its own it rebuilds the identical prompt.

**Colours are hex.** p10k accepts `#rrggbb` (`internal/p10k.zsh:535`), so the
palette files carry the theme's real hexes rather than 256-colour approximations.

**No spaces around `=`.** `_thm_bg = #1e1e2e` is a *command* in zsh, not an
assignment, and fails with `#1e1e2e not found`.

### Writing a bar

Copy an existing one and change the four formats it sets: `status-left`,
`window-status-format`, `window-status-current-format`, `status-right`, plus
`window-status-separator`. Use only `@thm_*` for colour. Keep the two
conditionals (`#{?#{==:#{window_name},#{pane_current_command}}, ,}` and
the `client_prefix` one) if you want the icon and prefix behaviour.

Verify it parses without touching your live session:

    tmux -L bartest -f ~/.config/tmux/tmux.conf new-session -d -s t
    tmux -L bartest display-message -p '#{W:#{E:window-status-current-format}}'
    tmux -L bartest kill-server

Separator glyphs are `` (solid), `` (round) and
`` (slant), all present in Hack Nerd Font. They are PUA codepoints,
so the counting trick above applies to them too.

## Adding a theme

    mkdir themes/palettes/<name>

Drop in three files. For `kitty.conf`, most themes publish a kitty palette
upstream — use it rather than transcribing hexes. For `tmux.conf`, copy an
existing one and swap the six colors in its header comment. For `nvim.lua`,
configure the colorscheme plugin, `vim.cmd.colorscheme(...)`, and `return` the
lualine theme name. Add the plugin to `nvim/lua/plugins.lua` if it's new.

## Adding an app

Give each theme directory one more file and have the app read it out of
`current/`. `btop` (`~/.config/btop`) takes `.theme` files and is the obvious
next one.
