# ~/.bashrc
#
# Bash reads this file for interactive shells AND whenever its standard input is
# a network connection — that is, for `ssh box somecommand`, which is not
# interactive (see `man bash`, "INVOCATION"). So this file has two tiers, split
# by the interactivity guard in the middle:
#
#   tier 1  ~/.config/bash/env.d/*.sh   environment and PATH only. Sourced
#                                       ABOVE the guard, so a remote
#                                       non-interactive command sees it.
#   tier 2  ~/.config/bash/*.sh         aliases, functions, prompts, hooks.
#                                       Sourced BELOW the guard.
#
# Anything that must exist for `ssh box somecommand` belongs in tier 1. Putting
# it in tier 2 is a silent failure: the variable is simply unset over that path.
# See docs/adr/0001-crumb-stows-itself-and-the-bashrc-seam.md.
#
# Nothing in this file may reference Omarchy, Hyprland, a theme path or any
# other desktop: crumb has to work on a machine that has none of them. The rice
# contributes its own tier-1 drop-in (env.d/00-omarchy.sh) from its own repo.

# ---------------------------------------------------------
# tier 1 — environment, for interactive AND non-interactive shells
# ---------------------------------------------------------

# nullglob is not optional here. Without it, an empty or absent drop-in
# directory leaves the pattern unexpanded and the loop tries to source the
# literal string "~/.config/bash/env.d/*.sh" — an error that reads like a
# corrupted rc file rather than a missing directory. Saved and restored so the
# option does not leak into the session.
if shopt -q nullglob; then _crumb_nullglob=on; else _crumb_nullglob=off; fi
shopt -s nullglob
for _crumb_f in "$HOME"/.config/bash/env.d/*.sh; do
  # shellcheck source=/dev/null  # drop-ins are discovered, not known statically
  source "$_crumb_f"
done
[[ $_crumb_nullglob == off ]] && shopt -u nullglob
unset -v _crumb_f _crumb_nullglob

# If not running interactively, stop here. Everything below is interactive-only.
[[ $- != *i* ]] && return

# ---------------------------------------------------------
# tier 2 — interactive setup
# ---------------------------------------------------------

# Same nullglob reasoning as tier 1.
if shopt -q nullglob; then _crumb_nullglob=on; else _crumb_nullglob=off; fi
shopt -s nullglob
for _crumb_f in "$HOME"/.config/bash/*.sh; do
  # shellcheck source=/dev/null
  source "$_crumb_f"
done
[[ $_crumb_nullglob == off ]] && shopt -u nullglob
unset -v _crumb_f _crumb_nullglob

# ---------------------------------------------------------
# 🔒  Machine-side identity
# ---------------------------------------------------------

# Anything carrying a name, email, account or secret lives here, untracked.
# Sourced last so it can override anything above. Missing file is fine.
# shellcheck source=/dev/null
[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local
