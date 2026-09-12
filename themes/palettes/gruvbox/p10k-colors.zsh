# gruvbox — Powerlevel10k segment colours
#
# The Catppuccin Starship powerline config, in gruvbox's colours. Role
# assignment follows gruvbox's own Starship preset (starship.rs/presets/
# gruvbox-rainbow), which orders the strip orange / yellow / aqua / blue and
# then two graduated dark plates:
#
#   red slot -> orange   directory -> yellow   git -> aqua
#   languages -> blue    python envs -> bg3    duration -> bg1
#
# The preset's DIM shades are used there as fills behind light text, but they
# are mid-tones: #d65d0e reaches only 3.4:1 under fg0 and 3.8:1 under the
# background, and #458588 fails both ways too. The bright half of the palette
# is used instead -- gruvbox's standard terminal colours -- carrying the
# background as text, like every other theme here.
#
# The last two keep the preset's dark plates and take fg0 as text, since a dark
# foreground cannot work on them.
#
# Overrides themes/p10k-colors.zsh, sourced first, which still supplies every
# segment this file does not name.

typeset -g POWERLEVEL9K_BACKGROUND=#282828

# orange -> os_icon
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=#fe8019
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=#282828

# yellow -> dir
typeset -g POWERLEVEL9K_DIR_BACKGROUND=#fabd2f
typeset -g POWERLEVEL9K_DIR_FOREGROUND=#282828
typeset -g POWERLEVEL9K_DIR_ANCHOR_BACKGROUND=#fabd2f
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=#282828
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=#282828

# aqua -> vcs
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=#8ec07c
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=#282828
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=#8ec07c
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=#282828
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=#8ec07c
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=#282828
typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=#8ec07c
typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=#282828
typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=#8ec07c
typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=#282828

# blue -> language versions
for _s in NODE_VERSION NODENV NVM NODEENV RUST_VERSION RUSTUP GO_VERSION GOENV \
          JAVA_VERSION JENV PHP_VERSION PHPENV KOTLIN_VERSION HASKELL_STACK RBENV LUAENV; do
  typeset -g POWERLEVEL9K_${_s}_BACKGROUND=#83a598
  typeset -g POWERLEVEL9K_${_s}_FOREGROUND=#282828
done
unset _s

# bg3 -> python environments
typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=#665c54
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=#fbf1c7
typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=#665c54
typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=#fbf1c7
typeset -g POWERLEVEL9K_PYENV_BACKGROUND=#665c54
typeset -g POWERLEVEL9K_PYENV_FOREGROUND=#fbf1c7
typeset -g POWERLEVEL9K_DOCKER_CONTEXT_BACKGROUND=#665c54
typeset -g POWERLEVEL9K_DOCKER_CONTEXT_FOREGROUND=#fbf1c7

# bg1 -> command duration
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=#3c3836
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=#fbf1c7

# ❯ takes the palette's green and red.
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=#b8bb26
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=#fb4934

# Status is not a capsule in this config — failure shows on ❯ instead.
typeset -g POWERLEVEL9K_STATUS_OK=false
typeset -g POWERLEVEL9K_STATUS_ERROR=false
