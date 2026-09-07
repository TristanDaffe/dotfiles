# Minimal — Powerlevel10k geometry
#
# Shape only. Colours come from the _thm_* palette the selected THEME sets
# (themes/current/p10k.zsh), so this file works with every theme — the same
# split as the tmux bar in this directory.
#
# Loaded by ~/.config/zsh/powerline.zsh, AFTER the palette and AFTER
# ~/.p10k.zsh, so these win. Switch with `bar-set minimal`.
#
# No powerline at all: the prompt equivalent of the transparent tmux bar.
# Foreground colour only, no filled blocks, no separator glyphs — p10k's
# 'lean' look wearing the theme's palette.

# ── geometry ───────────────────────────────────────────────────────────────
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''

# ── colours ────────────────────────────────────────────────────────────────
# Transparent, the prompt equivalent of the transparent tmux bar.
#
# Blanking the backgrounds is NOT enough. A rainbow-style ~/.p10k.zsh carries
# the segment's hue in its BACKGROUND and pairs it with a dark FOREGROUND --
# 56 segments in the current config use fg=ansi0. Drop the background alone and
# that text becomes near-black on the terminal background: invisible.
#
# So move the hue to the text instead, which is what a lean prompt does: the
# old background becomes the new foreground, then the background is cleared.
# Segments that already had a light foreground keep it.
#
# Done by walking $parameters rather than naming segments, so a future
# `p10k configure` that adds segments is handled without touching this file.
typeset -g POWERLEVEL9K_BACKGROUND=
() {
  emulate -L zsh
  local v seg fgvar bgvar bgval fgval
  local -a dark=($_thm_ansi0 $_thm_ansi8)
  for v in ${(k)parameters[(I)POWERLEVEL9K_*_BACKGROUND]}; do
    seg=${v%_BACKGROUND}
    fgvar=${seg}_FOREGROUND
    bgval=${(P)v}
    fgval=${(P)fgvar}
    if [[ -n $bgval ]] && { [[ -z $fgval ]] || (( ${dark[(I)$fgval]} )) }; then
      typeset -g $fgvar=$bgval
    fi
    typeset -g $v=
  done

  # Segments that were dark with no background to move: nothing to promote, so
  # fall back to the muted role. BATTERY and VI_MODE arrive this way.
  for v in ${(k)parameters[(I)POWERLEVEL9K_*_FOREGROUND]}; do
    seg=${v%_FOREGROUND}
    bgvar=${seg}_BACKGROUND
    [[ -n ${(P)bgvar} ]] && continue
    fgval=${(P)v}
    (( ${dark[(I)$fgval]} )) && typeset -g $v=$_thm_muted
  done
}
