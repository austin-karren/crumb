# Aliases and functions. Tier 2 — interactive shells only.

# ---------------------------------------------------------
# 🔧  direnv
# ---------------------------------------------------------

# Guarded so the shell still works on a machine without direnv installed
command -v direnv &>/dev/null && eval "$(direnv hook bash)"

# ---------------------------------------------------------
# 💻  Functions
# ---------------------------------------------------------

# Delete local branches whose remote tracking branch is gone
git-unload() {
  echo -e "\e[33m\e[0m Unloading dead branches..."
  git fetch -p && git branch -vv | grep ": gone]" | awk '{print $1}' | xargs -r git branch -D
}

# Refresh the git index so .gitignore updates take effect on tracked files
git-reindex() {
  git rm -r --cached . >/dev/null 2>&1
  git add -A
  git status --short
  echo "📋 Manifest updated. Ignored files have been offloaded!"
}

secret() {
  echo -e "\e[33m\e[0m Generating secret..."
  openssl rand -base64 32
}
