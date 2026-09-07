# tokyonight-moon — Powerlevel10k palette
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

_thm_bg=#222436
_thm_surface=#2f334d
_thm_overlay=#3b4261
_thm_muted=#828bb8
_thm_text=#c8d3f5
_thm_accent=#c099ff
_thm_warn=#ff757f

_thm_ansi0=#1b1d2b
_thm_ansi1=#ff757f
_thm_ansi2=#c3e88d
_thm_ansi3=#ffc777
_thm_ansi4=#82aaff
_thm_ansi5=#c099ff
_thm_ansi6=#86e1fc
_thm_ansi7=#828bb8
_thm_ansi8=#444a73
_thm_ansi9=#ff8d94
_thm_ansi10=#c7fb6d
_thm_ansi11=#ffd8ab
_thm_ansi12=#9ab8ff
_thm_ansi13=#caabff
_thm_ansi14=#b2ebff
_thm_ansi15=#c8d3f5

# Derived, for the prompt. Catppuccin's p10k themes put Crust -- the darkest
# colour in the palette -- on every filled segment; _thm_dark is this theme's
# equivalent. _thm_light is for the few segments sitting on a DARK background,
# where dark-on-dark would be invisible.
_thm_dark=#1b1d2b
_thm_light=#c8d3f5
# The 'success' fill. Normally the theme's green, but rose-pine's green is a
# dark teal (3.4:1 behind _thm_dark), so that one falls back to its lightest
# positive hue. Chosen per palette so the shared p10k-colors.zsh needs no
# per-theme logic.
_thm_ok=#c3e88d
