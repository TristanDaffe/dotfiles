# dracula — Powerlevel10k palette
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

_thm_bg=#282a36
_thm_surface=#343746
_thm_overlay=#44475a
_thm_muted=#6272a4
_thm_text=#f8f8f2
_thm_accent=#bd93f9
_thm_warn=#ff5555

_thm_ansi0=#21222c
_thm_ansi1=#ff5555
_thm_ansi2=#50fa7b
_thm_ansi3=#f1fa8c
_thm_ansi4=#bd93f9
_thm_ansi5=#ff79c6
_thm_ansi6=#8be9fd
_thm_ansi7=#f8f8f2
_thm_ansi8=#6272a4
_thm_ansi9=#ff6e6e
_thm_ansi10=#69ff94
_thm_ansi11=#ffffa5
_thm_ansi12=#d6acff
_thm_ansi13=#ff92df
_thm_ansi14=#a4ffff
_thm_ansi15=#ffffff

# Derived, for the prompt. Catppuccin's p10k themes put Crust -- the darkest
# colour in the palette -- on every filled segment; _thm_dark is this theme's
# equivalent. _thm_light is for the few segments sitting on a DARK background,
# where dark-on-dark would be invisible.
_thm_dark=#21222c
_thm_light=#ffffff
# The 'success' fill. Normally the theme's green, but rose-pine's green is a
# dark teal (3.4:1 behind _thm_dark), so that one falls back to its lightest
# positive hue. Chosen per palette so the shared p10k-colors.zsh needs no
# per-theme logic.
_thm_ok=#50fa7b
