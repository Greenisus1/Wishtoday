#!/usr/bin/env bash
# wishtoday - bootstrapper for WISHTODAY

SYS_DIR="$HOME/.wishtoday"
VERSION="0.5.5"
WISHTODAY="$SYS_DIR/wishtoday.sh"
UPDATE="$SYS_DIR/update.sh"
REPO_URL="https://raw.githubusercontent.com/Greenisus1/Wishtoday/main/wishtoday.sh"

# --- Auto-update on every run ---
auto_update() {
  mkdir -p "$SYS_DIR"
  echo "Checking for latest wishtoday.sh..."
  if curl -fsSL "$REPO_URL" -o "$WISHTODAY"; then
    chmod +x "$WISHTODAY"
    echo "wishtoday.sh updated."
  else
    echo "Warning: could not update from $REPO_URL"
  fi
}

boot() {
  auto_update
  echo "Booting WISHTODAY..."
  if [[ -x "$WISHTODAY" ]]; then
    "$WISHTODAY" "$@"
  else
    echo "wishtoday.sh not found. Run: wishtoday update-new-user"
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

  auto_update
  echo "Filesystem created and wishtoday.sh installed."
}

update_cmd() {
  auto_update
}

ver() { echo "wishtoday v$VERSION"; }
help() { echo "Usage: wishtoday boot | update-new-user | update | ver | help | wipe-clean"; }

wipe_clean() {
  echo "WARNING: This will permanently delete $SYS_DIR"
  read -r -p "Type YES to confirm: " ans
  if [[ "$ans" == "YES" ]]; then
    rm -rf "$SYS_DIR"
    echo "wishtoday folder deleted."
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
  update) update_cmd ;;
  ver) ver ;;
  help) help ;;
  wipe-clean) wipe_clean ;;
  *)
    echo "Unknown command: $cmd"
    help
    ;;
esac
