# Powerlevel10k — theme palette + bar geometry, from ~/.config/themes
#
# Sourced by ~/.zshrc AFTER ~/.p10k.zsh, so everything here overrides the
# wizard's generated config. Same split as the tmux bar:
#
#   themes/current/p10k.zsh       PALETTE  — _thm_<role> and _thm_ansi0-15
#   themes/p10k-colors.zsh        COLOUR   — the segment scheme, one file for
#                                            every theme
#   themes/current-bar/p10k.zsh   SHAPE    — separators and caps
#
#   theme-set <name>    changes the palette   (5 themes)
#   bar-set   <name>    changes the geometry  (4 bars)
#
# Switching is picked up automatically: see the precmd hook at the bottom.

[[ -o interactive ]] || return 0

_powerline_dir=$HOME/.config/themes

# Palette first: the geometry file reads _thm_* out of it.
#
# _powerline_applied records WHICH files were loaded, by resolved path, so the
# hook below can tell whether the symlinks have moved since.
_powerline_load() {
  emulate -L zsh
  local t=$_powerline_dir/current b=$_powerline_dir/current-bar
  # 1. palette   — defines _thm_<role> and _thm_ansi0-15
  [[ -r $t/p10k.zsh ]] && source $t/p10k.zsh
  # 2. colours   — the segment scheme, written against _thm_* so one file
  #                serves every theme.
  [[ -r $_powerline_dir/p10k-colors.zsh ]] && source $_powerline_dir/p10k-colors.zsh
  # 3. geometry  — separators and caps, and for `minimal` the un-filling
  [[ -r $b/p10k.zsh ]] && source $b/p10k.zsh
  _powerline_applied="${t:A}|${b:A}"
}

_powerline_load

# ── automatic reload ───────────────────────────────────────────────────────
# theme-set and bar-set run in their own process and cannot touch the variables
# of a shell that is already running — no script can. Signalling is not an
# option either: zsh's default action for SIGUSR1 is to TERMINATE, so the usual
# `pkill -USR1 zsh` would kill any zsh that has not installed a trap, including
# non-interactive ones running scripts.
#
# So each shell checks for itself, once per prompt. `${x:A}` resolves the
# symlink as a parameter expansion — no fork, nothing measurable per prompt —
# and when nothing has moved the hook is a single string comparison.
_powerline_precmd() {
  emulate -L zsh
  local t=$_powerline_dir/current b=$_powerline_dir/current-bar
  [[ "${t:A}|${b:A}" == "$_powerline_applied" ]] && return 0
  _powerline_load
  (( $+functions[p10k] )) && p10k reload
}

# PREPENDED, not appended. p10k registers its own precmd when oh-my-zsh loads
# the theme, which is before ~/.zshrc gets here; appending would leave us
# running after it, so `p10k reload` would only take effect one prompt later.
if (( ! ${precmd_functions[(I)_powerline_precmd]} )); then
  precmd_functions=(_powerline_precmd $precmd_functions)
fi

# Manual escape hatch: forces a reload even if the symlinks have not moved,
# which is what you want after EDITING a palette or bar file in place.
#
# `p10k reload` on its own is not enough for either case. It only sets
# _p9k__force_must_init=1 (powerlevel10k/internal/p10k.zsh:9339), re-running
# p10k's init against the POWERLEVEL9K_* values already in the shell; it never
# re-reads a file.
powerline-reload() {
  emulate -L zsh
  _powerline_applied=''
  _powerline_precmd
}
