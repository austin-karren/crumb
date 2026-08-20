# uv writes ~/.local/bin/env to put ~/.local/bin on PATH. Guarded: the file only
# exists on machines where uv (or another installer that writes it) has run.
# Also tier 1 — a remote non-interactive command needs ~/.local/bin too.
#
# The path uv's installer emits is "$HOME/.local/share/../bin/env"; the `../` is
# litter and resolves to the line below.
# shellcheck source=/dev/null
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
