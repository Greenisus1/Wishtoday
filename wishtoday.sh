#!/usr/bin/env bash
# wishnow.sh - bootstrapper for WISHTODAY

SYS_DIR="$HOME/.wishtoday"
VERSION="0.5"
WISHTODAY="$SYS_DIR/wishtoday.sh"
UPDATE="$SYS_DIR/update.sh"
REPO_URL="https://raw.githubusercontent.com/Greenisus1/Wishtoday/main/wishtoday.sh"

boot() {
  echo "Booting WISHTODAY..."
  if [[ -x "$WISHTODAY" ]]; then
    "$WISHTODAY" "$@"
  else
    echo "wishtoday.sh not found. Run: /wishtoday update-new-user"
  fi
}

update_new_user() {
  echo "Setting up filesystem at $SYS_DIR"
  mkdir -p "$SYS_DIR/wishes"

  # Write update.sh
  cat > "$UPDATE" <<'EOF'
#!/usr/bin/env bash
REPO_URL="https://raw.githubusercontent.com/Greenisus1/Wishtoday/main/wishtoday.sh"
TARGET="$HOME/.wishtoday/wishtoday.sh"

echo "Updating wishtoday.sh from $REPO_URL..."
curl -fsSL "$REPO_URL" -o "$TARGET" && chmod +x "$TARGET"
echo "Update complete."
EOF

  chmod +x "$UPDATE"

  echo "Fetching wishtoday.sh..."
  curl -fsSL "$REPO_URL" -o "$WISHTODAY" && chmod +x "$WISHTODAY"
  echo "Filesystem created and wishtoday.sh installed."
}

ver() { echo "wishnow v$VERSION"; }
help() { echo "wishnow is still an idea update coming soon"; }

wipe_clean() {
  echo "WARNING: This will permanently delete $SYS_DIR"
  read -r -p "Type YES to confirm: " ans
  if [[ "$ans" == "YES" ]]; then
    rm -rf "$SYS_DIR"
    echo "wishnow folder deleted."
  else
    echo "Cancelled."
  fi
}

# --- Command dispatcher ---
cmd="${1:-}"
shift || true

case "$cmd" in
  boot) boot "$@" ;;
  update-new-user) update_new_user ;;
  ver) ver ;;
  help) help ;;
  wipe-clean) wipe_clean ;;
  *)
    echo "Unknown command: $cmd"
    echo "Usage: /wishtoday boot | update-new-user | ver | help | wipe-clean"
    ;;
esac
