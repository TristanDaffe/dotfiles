# rose-pine — Powerlevel10k palette
#
# Two groups, both straight from this theme's own files:
#
#   _thm_<role>   the seven roles from tmux.conf (@thm_*)
#   _thm_ansi0-15 the terminal palette from kitty.conf (color0-15)
#
# The ANSI group is what makes a regenerated ~/.p10k.zsh land in theme
# colours: the p10k wizard assigns colours by ANSI index, and index N here
# is exactly the colour kitty paints for index N. See zsh/p10k-colors.zsh.
#
# No spaces around '=' — zsh would read that as a command, not an
# assignment, and fail with `#rrggbb not found`.

_thm_bg=#191724
_thm_surface=#1f1d2e
_thm_overlay=#26233a
_thm_muted=#908caa
_thm_text=#e0def4
_thm_accent=#c4a7e7
_thm_warn=#eb6f92

_thm_ansi0=#26233a
_thm_ansi1=#eb6f92
_thm_ansi2=#31748f
_thm_ansi3=#f6c177
_thm_ansi4=#9ccfd8
_thm_ansi5=#c4a7e7
_thm_ansi6=#ebbcba
_thm_ansi7=#e0def4
_thm_ansi8=#6e6a86
_thm_ansi9=#eb6f92
_thm_ansi10=#31748f
_thm_ansi11=#f6c177
_thm_ansi12=#9ccfd8
_thm_ansi13=#c4a7e7
_thm_ansi14=#ebbcba
_thm_ansi15=#e0def4

# Derived, for the prompt. Catppuccin's p10k themes put Crust -- the darkest
# colour in the palette -- on every filled segment; _thm_dark is this theme's
# equivalent. _thm_light is for the few segments sitting on a DARK background,
# where dark-on-dark would be invisible.
_thm_dark=#191724
_thm_light=#e0def4
# The 'success' fill. Normally the theme's green, but rose-pine's green is a
# dark teal (3.4:1 behind _thm_dark), so that one falls back to its lightest
# positive hue. Chosen per palette so the shared p10k-colors.zsh needs no
# per-theme logic.
_thm_ok=#ebbcba
