# Powerlevel10k segment colours
#
# One file, every theme: these reference the _thm_* variables the selected
# palette sets (themes/current/p10k.zsh), so nothing here is theme-specific.
# Sourced by zsh/powerline.zsh between the palette and the bar geometry, which
# puts it after ~/.p10k.zsh -- so it overrides the wizard without replacing it.
#
# Scheme transcribed from tolkonepiu/catppuccin-powerlevel10k-themes
# (.p10k-rainbow-catppuccin-mocha.zsh). It does three things the wizard does
# not: fills segments from the theme's own accents rather than terminal
# indices, uses ONE dark foreground everywhere, and gives the prompt a dark
# surface background instead of leaving it black.
#
#   catppuccin   here          used for
#   crust        _thm_dark     the foreground on every filled segment
#   surface0     _thm_surface  global background
#   lavender     _thm_ansi12   directory
#   mauve        _thm_accent   VCS clean
#   peach        _thm_ansi11   VCS modified
#   pink         _thm_ansi13   VCS untracked, clock
#   maroon       _thm_ansi9    VCS conflicted, errors
#   yellow       _thm_ansi3    VCS loading, jobs, direnv
#   green        _thm_ok       status ok (green, or the theme's lightest positive hue)
#   subtext1     _thm_ansi7    command execution time
#   text         _thm_text     OS icon
#   sky / teal   _thm_ansi14 / _thm_ansi6   python / node
#
# WHY THIS EXISTS AT ALL. 190 of the wizard's 204 colours are terminal indices
# 0-15, which kitty repaints from the theme -- those already follow theme-set on
# their own. Only 11 use indices 16-255, which are fixed and can never follow a
# theme, and three of those are the directory segment. So this file is really
# doing two jobs: applying the scheme above, and rescuing that stuck handful.
#
# Anything NOT named here keeps the wizard's own colour. That degrades softly:
# an index 0-15 still tracks the theme through kitty, it just will not be in
# this scheme. Add a line when you want a segment brought in.

# ── the prompt's own background ────────────────────────────────────────────
typeset -g POWERLEVEL9K_BACKGROUND=$_thm_surface

# ── filled segments: theme accent behind, one dark colour in front ─────────
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=$_thm_text
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$_thm_dark

typeset -g POWERLEVEL9K_DIR_BACKGROUND=$_thm_ansi12
typeset -g POWERLEVEL9K_DIR_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_DIR_ANCHOR_BACKGROUND=$_thm_ansi12
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$_thm_dark

typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=$_thm_accent
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=$_thm_ansi11
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=$_thm_ansi13
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=$_thm_ansi9
typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=$_thm_ansi3
typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=$_thm_dark

typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=$_thm_ok
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_STATUS_OK_PIPE_BACKGROUND=$_thm_ok
typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=$_thm_ansi9
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_BACKGROUND=$_thm_ansi9
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_BACKGROUND=$_thm_ansi9
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=$_thm_dark

typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=$_thm_ansi7
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=$_thm_ansi3
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_DIRENV_BACKGROUND=$_thm_ansi3
typeset -g POWERLEVEL9K_DIRENV_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_TIME_BACKGROUND=$_thm_ansi13
typeset -g POWERLEVEL9K_TIME_FOREGROUND=$_thm_dark

typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=$_thm_ansi14
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=$_thm_ansi14
typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_PYENV_BACKGROUND=$_thm_ansi14
typeset -g POWERLEVEL9K_PYENV_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND=$_thm_ansi6
typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_NODENV_BACKGROUND=$_thm_ansi6
typeset -g POWERLEVEL9K_NODENV_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_NVM_BACKGROUND=$_thm_ansi6
typeset -g POWERLEVEL9K_NVM_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_NODEENV_BACKGROUND=$_thm_ansi6
typeset -g POWERLEVEL9K_NODEENV_FOREGROUND=$_thm_dark

# ── text on the bare prompt, not on a fill ─────────────────────────────────
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=$_thm_accent
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND=$_thm_accent
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIVIS_FOREGROUND=$_thm_accent
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIOWR_FOREGROUND=$_thm_accent
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=$_thm_warn
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND=$_thm_warn
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIVIS_FOREGROUND=$_thm_warn
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIOWR_FOREGROUND=$_thm_warn

# The trailing dots that fill the gap to the right prompt.
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=$_thm_overlay

# ── on a DARK background: dark-on-dark would be invisible ──────────────────
typeset -g POWERLEVEL9K_BATTERY_FOREGROUND=$_thm_light
typeset -g POWERLEVEL9K_VI_MODE_FOREGROUND=$_thm_light

# ── stuck in the 16-255 range, so they could never follow a theme ──────────
typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_PERLBREW_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_TIMEWARRIOR_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_RVM_BACKGROUND=$_thm_ansi9
typeset -g POWERLEVEL9K_RVM_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND=$_thm_ansi11
typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=$_thm_dark
typeset -g POWERLEVEL9K_ASDF_RUST_BACKGROUND=$_thm_ansi11
typeset -g POWERLEVEL9K_ASDF_RUST_FOREGROUND=$_thm_dark
