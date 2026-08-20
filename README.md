# crumb

Dev config that does not need a desktop. The real files live here; GNU stow
symlinks them into `$HOME`.

`~/shokupan` owns the Linux rice (Hyprland, terminals, themes) and needs
Omarchy. `~/claude-config` owns agent config. This repo owns the config that
travels — shell aliases and functions, git, mise, Zed — and must work on a
machine with no Omarchy and no desktop at all.

## Materialize

One flat Stow package whose paths mirror `$HOME` directly (shokupan ADR-0002),
so the repo root *is* the package:

```
cd ~/crumb && stow --adopt -t ~ .   # --adopt takes ownership of existing files in place
```

`--adopt` overwrites the repo copy with the live file, silently. `git diff`
immediately after stowing is not optional.

## Identity

No tracked file here contains a name or an email address (shokupan ADR-0003).
`.config/git/config` ends with an include of `~/.gitconfig.local`, which is
untracked and holds `user.name` and `user.email`. A missing include fails
silently — git just says "please tell me who you are".

`~/.gitconfig.local` must therefore contain, under a `[user]` section:

```
[user]
	name = <your name>
	email = <your email>
```

The `email` line is already there; `name` moved out of the tracked config and
has to join it. The literal values are deliberately not written here — this file
is tracked, and no tracked file in this repo carries a name or an email.

## Shell

`.bashrc` sources two drop-in directories, split by the interactivity guard:
`~/.config/bash/env.d/*.sh` above it (environment and PATH only, so
`ssh box somecommand` sees it) and `~/.config/bash/*.sh` below it (aliases,
functions, interactive setup). `~/.bashrc.local` is sourced last and is
untracked. See [ADR-0001](./docs/adr/0001-crumb-stows-itself-and-the-bashrc-seam.md).

## Decisions

| ADR | Title | Status |
| --- | --- | --- |
| [0001](./docs/adr/0001-crumb-stows-itself-and-the-bashrc-seam.md) | crumb stows itself, and the `.bashrc` seam that keeps it desktop-independent | accepted |
| [0002](./docs/adr/0002-zed-and-mac-config-stay-duplicated.md) | Zed and the Mac config stay duplicated | accepted |
