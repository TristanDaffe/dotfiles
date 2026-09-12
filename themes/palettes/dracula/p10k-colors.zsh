# dracula — Powerlevel10k segment colours
#
# The Catppuccin Starship powerline config, in this theme's colours. Each of
# its six palette roles maps to the equivalent hue from the official Dracula spec:
#
#   red  peach  yellow  green  sapphire  lavender   ->   red / orange / yellow / green / cyan / purple
#
# Every segment carries crust, the palette's darkest shade, as its text --
# one foreground across the whole strip, as the original does.
#
# Dracula names its peach 'orange', its sapphire 'cyan' and its lavender
# 'purple'. crust is #21222c, the darker shade Dracula ships beside its base.
#
# Overrides themes/p10k-colors.zsh, sourced first, which still supplies every
# segment this file does not name.

typeset -g POWERLEVEL9K_BACKGROUND=#21222c

# red      -> os_icon
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=#ff5555
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=#21222c

# peach    -> dir, dir_anchor
typeset -g POWERLEVEL9K_DIR_BACKGROUND=#ffb86c
typeset -g POWERLEVEL9K_DIR_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_DIR_ANCHOR_BACKGROUND=#ffb86c
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=#21222c

# yellow   -> vcs_clean, vcs_modified, vcs_untracked, vcs_conflicted …
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=#f1fa8c
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=#f1fa8c
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=#f1fa8c
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=#f1fa8c
typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=#f1fa8c
typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=#21222c

# green    -> node_version, nodenv, nvm, nodeenv …
typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_NODENV_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_NODENV_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_NVM_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_NVM_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_NODEENV_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_NODEENV_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_RUSTUP_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_RUSTUP_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_GOENV_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_GOENV_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_JAVA_VERSION_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_JENV_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_JENV_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_PHP_VERSION_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_PHP_VERSION_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_PHPENV_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_PHPENV_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_KOTLIN_VERSION_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_KOTLIN_VERSION_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_HASKELL_STACK_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_HASKELL_STACK_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_RBENV_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_RBENV_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_LUAENV_BACKGROUND=#50fa7b
typeset -g POWERLEVEL9K_LUAENV_FOREGROUND=#21222c

# sapphire -> virtualenv, anaconda, pyenv, docker_context
typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=#8be9fd
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=#8be9fd
typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_PYENV_BACKGROUND=#8be9fd
typeset -g POWERLEVEL9K_PYENV_FOREGROUND=#21222c
typeset -g POWERLEVEL9K_DOCKER_CONTEXT_BACKGROUND=#8be9fd
typeset -g POWERLEVEL9K_DOCKER_CONTEXT_FOREGROUND=#21222c

# lavender -> command_execution_time
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=#bd93f9
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=#21222c

# ❯ takes the same green and red as the rest of the strip.
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=#50fa7b
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=#ff5555

# Status is not a capsule in this config -- failure shows on ❯ instead.
typeset -g POWERLEVEL9K_STATUS_OK=false
typeset -g POWERLEVEL9K_STATUS_ERROR=false
