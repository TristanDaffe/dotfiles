# rose-pine — Powerlevel10k segment colours
#
# The Catppuccin Starship powerline config, in this theme's colours. Each of
# its six palette roles maps to the equivalent hue from the Rosé Pine palette:
#
#   red  peach  yellow  green  sapphire  lavender   ->   love / rose / gold / foam / pine / iris
#
# Every segment carries crust, the palette's darkest shade, as its text --
# one foreground across the whole strip, as the original does.
#
# Rosé Pine has exactly six hues and one of them, pine, is too dark to be a
# fill: #31748f carries text at 3.4:1 either way. The sapphire slot uses pine's
# Moon shade #3e8fb0 instead, which reaches 4.84:1 and is still Rosé Pine's own.
#
# Overrides themes/p10k-colors.zsh, sourced first, which still supplies every
# segment this file does not name.

typeset -g POWERLEVEL9K_BACKGROUND=#191724

# red      -> os_icon
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=#eb6f92
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=#191724

# peach    -> dir, dir_anchor
typeset -g POWERLEVEL9K_DIR_BACKGROUND=#ebbcba
typeset -g POWERLEVEL9K_DIR_FOREGROUND=#191724
typeset -g POWERLEVEL9K_DIR_ANCHOR_BACKGROUND=#ebbcba
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=#191724

# yellow   -> vcs_clean, vcs_modified, vcs_untracked, vcs_conflicted …
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=#f6c177
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=#191724
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=#f6c177
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=#191724
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=#f6c177
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=#191724
typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=#f6c177
typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=#191724
typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=#f6c177
typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=#191724

# green    -> node_version, nodenv, nvm, nodeenv …
typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=#191724
typeset -g POWERLEVEL9K_NODENV_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_NODENV_FOREGROUND=#191724
typeset -g POWERLEVEL9K_NVM_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_NVM_FOREGROUND=#191724
typeset -g POWERLEVEL9K_NODEENV_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_NODEENV_FOREGROUND=#191724
typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=#191724
typeset -g POWERLEVEL9K_RUSTUP_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_RUSTUP_FOREGROUND=#191724
typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=#191724
typeset -g POWERLEVEL9K_GOENV_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_GOENV_FOREGROUND=#191724
typeset -g POWERLEVEL9K_JAVA_VERSION_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND=#191724
typeset -g POWERLEVEL9K_JENV_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_JENV_FOREGROUND=#191724
typeset -g POWERLEVEL9K_PHP_VERSION_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_PHP_VERSION_FOREGROUND=#191724
typeset -g POWERLEVEL9K_PHPENV_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_PHPENV_FOREGROUND=#191724
typeset -g POWERLEVEL9K_KOTLIN_VERSION_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_KOTLIN_VERSION_FOREGROUND=#191724
typeset -g POWERLEVEL9K_HASKELL_STACK_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_HASKELL_STACK_FOREGROUND=#191724
typeset -g POWERLEVEL9K_RBENV_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_RBENV_FOREGROUND=#191724
typeset -g POWERLEVEL9K_LUAENV_BACKGROUND=#9ccfd8
typeset -g POWERLEVEL9K_LUAENV_FOREGROUND=#191724

# sapphire -> virtualenv, anaconda, pyenv, docker_context
typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=#3e8fb0
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=#191724
typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=#3e8fb0
typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=#191724
typeset -g POWERLEVEL9K_PYENV_BACKGROUND=#3e8fb0
typeset -g POWERLEVEL9K_PYENV_FOREGROUND=#191724
typeset -g POWERLEVEL9K_DOCKER_CONTEXT_BACKGROUND=#3e8fb0
typeset -g POWERLEVEL9K_DOCKER_CONTEXT_FOREGROUND=#191724

# lavender -> command_execution_time
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=#c4a7e7
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=#191724

# ❯ takes the same green and red as the rest of the strip.
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=#9ccfd8
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=#eb6f92

# Status is not a capsule in this config -- failure shows on ❯ instead.
typeset -g POWERLEVEL9K_STATUS_OK=false
typeset -g POWERLEVEL9K_STATUS_ERROR=false
