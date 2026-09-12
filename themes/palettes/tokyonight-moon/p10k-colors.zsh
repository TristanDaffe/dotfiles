# tokyonight-moon — Powerlevel10k segment colours
#
# The Starship Tokyo Night preset (starship.rs/presets/tokyo-night), applied
# segment for segment. Unlike the other themes here, this one does not map a
# palette's named hues onto the strip: the preset defines its own literal
# colours, and they are a graduated descent rather than a row of accents —
#
#   #a3aed2  light plate      os
#   #769ff0  blue             directory
#   #394260  navy             git
#   #212736  darker navy      language versions, python environments
#   #1d2230  darkest          command duration
#
# with #769ff0 reused as the TEXT on the dark half, which is what ties the
# cascade together.
#
# Two of the preset's own pairings are low contrast: directory is #e3e5e5 on
# #769ff0 at 2.08:1, and git is #769ff0 on #394260 at 3.76:1. Both are kept as
# published. Swapping directory's foreground to #1b1d2b would take it to 6.3:1
# if the washed-out look becomes a problem.
#
# The preset defines no prompt character colours, so those keep the Moon
# palette's green and red.
#
# Overrides themes/p10k-colors.zsh, sourced first, which still supplies every
# segment this file does not name.

typeset -g POWERLEVEL9K_BACKGROUND=#1d2230

# light plate -> os_icon
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=#a3aed2
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=#090c0c

# blue -> dir
typeset -g POWERLEVEL9K_DIR_BACKGROUND=#769ff0
typeset -g POWERLEVEL9K_DIR_FOREGROUND=#e3e5e5
typeset -g POWERLEVEL9K_DIR_ANCHOR_BACKGROUND=#769ff0
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=#e3e5e5
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=#e3e5e5

# The branch text and dirty markers come from my_git_formatter() in ~/.p10k.zsh,
# which carries its own inline colour codes, so VCS_*_FOREGROUND alone does not
# reach them. zsh/powerline.zsh rewrites those codes to this value.
_thm_git_text=#769ff0

# navy -> vcs, with blue carried through as text. The preset uses #769ff0 here,
# which reads at only 3.76:1 on this plate; the Moon palette's own bright blue
# is the same hue a step lighter and reaches 5.03:1.
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=#394260
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=#9ab8ff
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=#394260
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=#9ab8ff
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=#394260
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=#9ab8ff
typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=#394260
typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=#9ab8ff
typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=#394260
typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=#9ab8ff

# darker navy -> language versions and python environments
for _s in NODE_VERSION NODENV NVM NODEENV RUST_VERSION RUSTUP GO_VERSION GOENV \
          JAVA_VERSION JENV PHP_VERSION PHPENV KOTLIN_VERSION HASKELL_STACK RBENV LUAENV \
          VIRTUALENV ANACONDA PYENV DOCKER_CONTEXT; do
  typeset -g POWERLEVEL9K_${_s}_BACKGROUND=#212736
  typeset -g POWERLEVEL9K_${_s}_FOREGROUND=#769ff0
done
unset _s

# darkest -> command duration, the preset's time slot
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=#1d2230
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=#a0a9cb

# ❯ — not defined by the preset, so the Moon palette's green and red.
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=#c3e88d
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=#ff757f

# Status is not a capsule in this config — failure shows on ❯ instead.
typeset -g POWERLEVEL9K_STATUS_OK=false
typeset -g POWERLEVEL9K_STATUS_ERROR=false
