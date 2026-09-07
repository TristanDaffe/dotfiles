# duskfox — Powerlevel10k palette
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

_thm_bg=#232136
_thm_surface=#2d2a45
_thm_overlay=#433c59
_thm_muted=#817c9c
_thm_text=#e0def4
_thm_accent=#c4a7e7
_thm_warn=#eb6f92

_thm_ansi0=#393552
_thm_ansi1=#eb6f92
_thm_ansi2=#a3be8c
_thm_ansi3=#f6c177
_thm_ansi4=#569fba
_thm_ansi5=#c4a7e7
_thm_ansi6=#9ccfd8
_thm_ansi7=#e0def4
_thm_ansi8=#47407d
_thm_ansi9=#f083a2
_thm_ansi10=#b1d196
_thm_ansi11=#f9cb8c
_thm_ansi12=#65b1cd
_thm_ansi13=#ccb1ed
_thm_ansi14=#a6dae3
_thm_ansi15=#e2e0f7

# Derived, for the prompt. Catppuccin's p10k themes put Crust -- the darkest
# colour in the palette -- on every filled segment; _thm_dark is this theme's
# equivalent. _thm_light is for the few segments sitting on a DARK background,
# where dark-on-dark would be invisible.
_thm_dark=#232136
_thm_light=#e2e0f7
# The 'success' fill. Normally the theme's green, but rose-pine's green is a
# dark teal (3.4:1 behind _thm_dark), so that one falls back to its lightest
# positive hue. Chosen per palette so the shared p10k-colors.zsh needs no
# per-theme logic.
_thm_ok=#a3be8c
