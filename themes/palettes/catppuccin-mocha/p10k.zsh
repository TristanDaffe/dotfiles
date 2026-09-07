# catppuccin-mocha — Powerlevel10k palette
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

_thm_bg=#1e1e2e
_thm_surface=#313244
_thm_overlay=#45475a
_thm_muted=#7f849c
_thm_text=#cdd6f4
_thm_accent=#cba6f7
_thm_warn=#f38ba8

_thm_ansi0=#45475a
_thm_ansi1=#f38ba8
_thm_ansi2=#a6e3a1
_thm_ansi3=#f9e2af
_thm_ansi4=#89b4fa
_thm_ansi5=#f5c2e7
_thm_ansi6=#94e2d5
_thm_ansi7=#bac2de
_thm_ansi8=#585b70
_thm_ansi9=#f38ba8
_thm_ansi10=#a6e3a1
_thm_ansi11=#f9e2af
_thm_ansi12=#89b4fa
_thm_ansi13=#f5c2e7
_thm_ansi14=#94e2d5
_thm_ansi15=#a6adc8

# Derived, for the prompt. Catppuccin's p10k themes put Crust -- the darkest
# colour in the palette -- on every filled segment; _thm_dark is this theme's
# equivalent. _thm_light is for the few segments sitting on a DARK background,
# where dark-on-dark would be invisible.
_thm_dark=#1e1e2e
_thm_light=#cdd6f4
# The 'success' fill. Normally the theme's green, but rose-pine's green is a
# dark teal (3.4:1 behind _thm_dark), so that one falls back to its lightest
# positive hue. Chosen per palette so the shared p10k-colors.zsh needs no
# per-theme logic.
_thm_ok=#a6e3a1
