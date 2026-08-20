---
status: accepted
---

# crumb stows itself, and the `.bashrc` seam that keeps it desktop-independent

crumb is a single flat Stow package that installs itself with `stow`, the same
way `~/shokupan` does (shokupan ADR-0002), and it does **not** go through
`loaf`. `loaf` is the Omarchy-layer tool: it heals the rice, reasserts themes
and checks paths that only exist when Omarchy does. A repo whose entire premise
is that it works on a machine with no Omarchy cannot take a dependency on the
Omarchy layer's tool, so `loaf` never learns about a second tree. Plain `stow` plus
this repo's own README is the whole install story. `~/claude-config` is the
working precedent: it self-stows, `loaf` has never known about it, and nothing
has been lost by that.

The mechanism that makes "does not depend on the desktop" true rather than
aspirational is the seam in `.bashrc`. That file contains no Omarchy reference
at all. Instead it sources two glob-ordered drop-in directories, split by the
interactivity guard:

- `~/.config/bash/env.d/*.sh` — sourced **above** `[[ $- != *i* ]] && return`.
  Environment and PATH only.
- `~/.config/bash/*.sh` — sourced **below** it. Aliases, functions, interactive
  setup, numbered so ordering is explicit.

The rice drops its own `env.d/00-omarchy.sh` into tier 1 from its own repo. On a
machine with no rice, nothing lands there and crumb's `.bashrc` is silent.

The split is not cosmetic. Bash reads `~/.bashrc` whenever its standard input is
a network connection — `ssh box somecommand` — which is not interactive. In
`shokupan`'s `.bashrc` everything, including `OMARCHY_PATH`, sits below the
interactivity guard, so over that path `OMARCHY_PATH` comes back `UNSET`.
Anything a remote non-interactive command needs must be in tier 1.

## Consequences

Both globs are `nullglob`-guarded, and the option is saved and restored around
each loop so it does not leak into the session. Without `nullglob`, an empty or
absent drop-in directory leaves the pattern unexpanded and the loop sources the
literal string `~/.config/bash/env.d/*.sh`. The resulting error names a path
containing a `*` and reads like a corrupted rc file rather than a missing
directory — the worst possible failure for the case this repo exists to support:
a fresh machine with nothing installed yet.

Ordering between the two tiers is fixed by the file, ordering within a tier is
the glob's, i.e. lexical. Hence numeric prefixes: `10-pnpm.sh` before
`50-aliases.sh` is a statement, not an accident. Renaming a drop-in changes when
it runs.

`~/.bashrc.local` is still sourced last, from `.bashrc` itself rather than from
a drop-in, because "last" has to mean after both tiers. It is untracked and
holds identity and secrets (shokupan ADR-0003).

Two repos now both write into `~/.config/bash/`. They are disjoint by
convention, not by enforcement: the rice owns `00-omarchy.sh`, crumb owns
everything else it ships. A collision would surface as a stow conflict at
install time, which is the loud failure and therefore acceptable.
