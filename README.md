# crumb

Dev config that does not need a desktop. The real files live here; GNU stow
symlinks them into `$HOME`.

`~/shokupan` owns the Linux rice (Hyprland, terminals, themes) and needs
Omarchy. `~/claude-config` owns agent config. This repo owns the config that
travels — shell aliases and functions, git, mise, Zed — and must work on a
machine with no Omarchy and no desktop at all.

## Materialize

```
stow -d ~/crumb -t ~ crumb
```

## Identity

No tracked file here contains a name or an email address (shokupan ADR-0003).
`.config/git/config` ends with an include of `~/.gitconfig.local`, which is
untracked and holds `user.name` and `user.email`. A missing include fails
silently — git just says "please tell me who you are".
