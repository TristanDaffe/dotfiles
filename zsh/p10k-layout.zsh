# Powerlevel10k prompt layout
#
# One strip of coloured capsules:
#
#     …/terminal-doom   main    v22.1.0    3.12    1.2s 
#   \____/\_______________/\________/\_________/\________/\_______/
#     red       peach        yellow     green    sapphire  lavender
#     os        directory     git      language   python    duration
#
# Ported from the Catppuccin Starship powerline config, segment for segment.
# Username and clock are deliberately absent; the clock's lavender slot is
# reused by command duration, which is the module that followed it there.
#
# Sourced by zsh/powerline.zsh AFTER ~/.p10k.zsh and after the bar geometry, so
# it wins over both. Structure only -- colours live in themes/p10k-colors.zsh,
# and the rounded end caps come from the `capsule` bar (`bar-set capsule`).
#
# Kept here rather than in ~/.p10k.zsh so that re-running `p10k configure`
# cannot undo it, and so it is version-controlled with the rest of the config.

# Icons. The wizard wrote MODE=ascii, which is why no icon rendered at all.
# nerdfont-v3 makes p10k pick a per-OS glyph by itself: an Apple on macOS, the
# distro's own logo on Linux (Arch, Debian, Fedora, ...). Nothing to hardcode.
typeset -g POWERLEVEL9K_MODE=nerdfont-v3

# ── the strip ──────────────────────────────────────────────────────────────
# Everything on the left, nothing on the right, then a newline and the prompt
# character, so what you type starts on its own line under the strip.
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon                 # red
    dir                     # peach
    vcs                     # yellow
    node_version            # green — the language block, one capsule
    rust_version
    go_version
    java_version
    php_version
    kotlin_version
    haskell_stack
    virtualenv              # sapphire — python environments, conda's slot
    anaconda
    pyenv
    docker_context
    command_execution_time  # lavender
    newline
    prompt_char
)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

# ── directory ──────────────────────────────────────────────────────────────
# Short paths whole, long ones cut to their tail behind an ellipsis:
#
#   ~/.config                                    ->  ~/.config
#   ~/.config/themes/palettes/tokyonight-moon    ->  …/palettes/tokyonight-moon
#
# SHORTEN_DIR_LENGTH is the budget in characters, and it MUST be set here:
# ~/.p10k.zsh leaves it at 1, which truncate_absolute reads as "keep one
# trailing character" and rendered that path as a bare "…n".
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_absolute
typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=32
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=24
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='…/'
typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION=

# ── git ────────────────────────────────────────────────────────────────────
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '
typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=

# ── language and environment capsules ──────────────────────────────────────
# Version segments show only inside a matching project, exactly as they do in
# the Starship config -- they are not padded to stay on screen.
typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true
typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true
typeset -g POWERLEVEL9K_PHP_VERSION_PROJECT_ONLY=true
typeset -g POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY=true

# ── command duration ───────────────────────────────────────────────────────
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

# ── prompt character ───────────────────────────────────────────────────────
# ❯ green on success, red on failure -- the Starship config's [character].
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_CONTENT_EXPANSION='❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_CONTENT_EXPANSION='❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=

# ── status ─────────────────────────────────────────────────────────────────
# The small always-there segment. STATUS_OK=false hid it after every successful
# command; true keeps the capsule on screen with no glyph inside, so the strip
# does not change width as you work. A failure fills it with the exit code.
typeset -g POWERLEVEL9K_STATUS_OK=true
#
# The content is a SPACE, not empty: p10k drops any segment whose content comes
# out empty, which removed the capsule altogether.
typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION=
typeset -g POWERLEVEL9K_STATUS_OK_CONTENT_EXPANSION=' '
typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION=
typeset -g POWERLEVEL9K_STATUS_OK_PIPE_CONTENT_EXPANSION=' '
typeset -g POWERLEVEL9K_STATUS_ERROR=true
typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION=
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true

# ── the line you type on ───────────────────────────────────────────────────
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
