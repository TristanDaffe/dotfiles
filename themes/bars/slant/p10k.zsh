# Slant powerline — Powerlevel10k geometry
#
# Shape only. Colours come from the _thm_* palette the selected THEME sets
# (themes/current/p10k.zsh), so this file works with every theme — the same
# split as the tmux bar in this directory.
#
# Loaded by ~/.config/zsh/powerline.zsh, AFTER the palette and AFTER
# ~/.p10k.zsh, so these win. Switch with `bar-set slant`.
#
# Slanted transitions, matching the slant tmux bar: same U+E0B8 / U+E0BE
# triangles, so the prompt and the bar cut at the same angle.

# ── geometry ───────────────────────────────────────────────────────────────
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0B8'
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0BE'
typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$_thm_muted}\uE0B9"
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$_thm_muted}\uE0BF"
typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B8'
typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0BE'
typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
#
# COLOURS ARE NOT SET HERE. themes/p10k-colors.zsh holds the segment scheme and
# is sourced just before this file. This is geometry only, which is why all
# three filled bars share one colour set.
