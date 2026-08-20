# pnpm — environment, not interactive setup, so it lives in tier 1: `ssh box
# pnpm install` needs this on PATH.
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
