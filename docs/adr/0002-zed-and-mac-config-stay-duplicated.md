---
status: accepted
---

# Zed and the Mac config stay duplicated

Zed's `settings.json` and `keymap.json` are tracked here and *also* tracked in
the macOS `dotfiles` repo, and the two copies have diverged. They stay
duplicated: no shared repo, no host detection, no symlink farm spanning both
machines. Divergence is accepted as the cost.

This revisits shokupan ADR-0002, which kept the rice separate from the macOS
dotfiles on the premise that "the two platforms overlap on almost nothing but
`.gitconfig`, and the shell differs (bash here, zsh there)". Half that premise
had gone stale. The overlap was never just `.gitconfig` — Zed was tracked in
both repos and had drifted apart: Linux `settings.json` 6215B against macOS
3846B, Linux `keymap.json` 1614B against macOS 1035B. The conclusion survives
anyway, on the half that still holds. The shells genuinely differ, so the bulk
of both repos cannot be shared regardless, and unifying two small JSON files
would mean introducing host detection — or a merge discipline — to serve the
only files that actually overlap.

Zed lives in crumb rather than in the rice because it is editor taste, not
desktop: it must work on a headless box.

## Consequences

A Zed setting you want on both machines has to be applied twice, by hand, and
nothing detects that you only did it once. The divergence measured above is not
a bug to be fixed later; it is the state this decision accepts.

The two copies are free to drift on purpose, which is the upside: Linux-only
keybinds do not need guarding, and neither file carries dead platform
conditionals.

If the overlap ever grows past Zed and `.gitconfig` — a shared shell, say — the
premise fails on its remaining half too and this decision should be reopened.
