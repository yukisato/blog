#!/usr/bin/env bash
#
# Install Git hooks for this repository
#
# This script sets up pre-commit hook to validate Jekyll builds before committing.
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"
PRE_COMMIT_HOOK="$HOOKS_DIR/pre-commit"

# Check if we're in a git repository
if [ ! -d "$REPO_ROOT/.git" ]; then
  echo "Error: Not a git repository"
  exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Install pre-commit hook
echo "Installing pre-commit hook..."
cat > "$PRE_COMMIT_HOOK" << 'EOF'
#!/usr/bin/env bash
# Pre-commit hook installed by scripts/install-hooks.sh
# This hook validates Jekyll builds before allowing commits

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)"
exec "$SCRIPT_DIR/pre-commit-hook.sh"
EOF

chmod +x "$PRE_COMMIT_HOOK"
chmod +x "$SCRIPT_DIR/pre-commit-hook.sh"

echo "✅ Pre-commit hook installed successfully!"
echo ""
echo "The hook will now:"
echo "  - Check if posts or config files were modified"
echo "  - Build the Jekyll site (with --future flag)"
echo "  - Run htmlproofer to catch link/image errors"
echo ""
echo "To skip the hook (not recommended), use: git commit --no-verify"
