#!/usr/bin/env bash
#
# link-dotfiles.sh — symlink files from ~/dotfiles into ~ with a leading dot.
#
#   ~/dotfiles/bashrc            -> ~/.bashrc
#   ~/dotfiles/config/nvim/init  -> ~/.config/nvim/init
#
# Directories named "bin" are skipped. Files are stored WITHOUT the leading
# dot in the repo; the dot is added on the first path component when linking.
#
# Usage:
#   ./link-dotfiles.sh            # create missing links
#   ./link-dotfiles.sh --dry-run  # show what would happen, change nothing
#   ./link-dotfiles.sh --force    # back up anything in the way, then link

set -euo pipefail
shopt -s nullglob          # an empty directory expands to nothing, not "dir/*"

DOTFILES_DIR="${HOME}/dotfiles"
DRY_RUN=false
FORCE=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --force)   FORCE=true ;;
    -h|--help) sed -n '2,18p' "$0"; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

log() { printf '%s\n' "$*"; }

# Run a command, or just print it in dry-run mode.
run() {
  if "$DRY_RUN"; then
    log "  [dry-run] $*"
  else
    "$@"
  fi
}

link_file() {
  local src="$1"                       # absolute path inside ~/dotfiles
  local rel="${src#"${DOTFILES_DIR}/"}" # path relative to ~/dotfiles
  local dest="${HOME}/.${rel}"          # dot-prefixed destination
  local dest_dir
  dest_dir="$(dirname "$dest")"

  # Already linked correctly — nothing to do.
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    log "ok      ${dest}"
    return
  fi

  # Something is already in the way.
  if [[ -e "$dest" || -L "$dest" ]]; then
    if "$FORCE"; then
      run mv "$dest" "${dest}.bak"
      log "backup  ${dest} -> ${dest}.bak"
    else
      log "skip    ${dest} (exists; use --force to back up and replace)"
      return
    fi
  fi

  run mkdir -p "$dest_dir"
  run ln -s "$src" "$dest"
  log "link    ${dest} -> ${src}"
}

walk() {
  local dir="$1" entry base
  for entry in "$dir"/*; do
    base="${entry##*/}"
    if [[ -d "$entry" ]]; then
      if [[ "$base" == "bin" ]]; then
        log "skip    ${entry}/ (bin)"
        continue
      fi
      walk "$entry"
    elif [[ -f "$entry" ]]; then
      link_file "$entry"
    fi
  done
}

main() {
  if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "error: ${DOTFILES_DIR} does not exist" >&2
    exit 1
  fi

  "$DRY_RUN" && log "(dry run — no changes will be made)"
  walk "$DOTFILES_DIR"

  if [[ -f "${HOME}/.bash_profile" ]] && ! "$DRY_RUN"; then
    # shellcheck disable=SC1091
    source "${HOME}/.bash_profile"
  fi
}

main
