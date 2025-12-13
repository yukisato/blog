#!/usr/bin/env bash
#
# Pre-commit hook: Build and test Jekyll site before commit
#
# This hook runs when you commit changes. It checks if any posts were modified,
# and if so, builds the site and runs htmlproofer to catch errors early.
#
# Requirements: Docker Compose
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if any posts or config files were changed
POSTS_CHANGED=false
CONFIG_CHANGED=false

while IFS= read -r file; do
  if [[ "$file" == _posts/*.md ]] || [[ "$file" == _posts/*.markdown ]]; then
    POSTS_CHANGED=true
  fi
  if [[ "$file" == _config.yml ]] || [[ "$file" == _includes/* ]] || [[ "$file" == _plugins/* ]]; then
    CONFIG_CHANGED=true
  fi
done < <(git diff --cached --name-only --diff-filter=ACM)

# Skip if no relevant files changed
if [ "$POSTS_CHANGED" = false ] && [ "$CONFIG_CHANGED" = false ]; then
  exit 0
fi

echo -e "${YELLOW}🔍 Pre-commit: Building and testing Jekyll site...${NC}"

# Get UID and GID for Docker
export UID=$(id -u)
export GID=$(id -g)

# Build the site with --future flag (to include future-dated posts)
echo -e "${YELLOW}📦 Building site...${NC}"
if ! UID=$UID GID=$GID docker compose run --rm site bash -lc "bundle exec jekyll build --future" > /tmp/jekyll-build.log 2>&1; then
  echo -e "${RED}❌ Jekyll build failed!${NC}"
  echo "Build output:"
  cat /tmp/jekyll-build.log
  rm -f /tmp/jekyll-build.log
  exit 1
fi

# Run htmlproofer (with --future flag for build, but test without external links)
echo -e "${YELLOW}🔍 Running htmlproofer...${NC}"
if ! UID=$UID GID=$GID docker compose run --rm site bash -lc "bundle exec htmlproofer _site --disable-external --ignore-urls '/^http:\/\/127.0.0.1/,/^http:\/\/0.0.0.0/,/^http:\/\/localhost/'" > /tmp/htmlproofer.log 2>&1; then
  echo -e "${RED}❌ htmlproofer found errors!${NC}"
  echo "Errors:"
  cat /tmp/htmlproofer.log
  rm -f /tmp/jekyll-build.log /tmp/htmlproofer.log
  exit 1
fi

echo -e "${GREEN}✅ Build and tests passed!${NC}"
rm -f /tmp/jekyll-build.log /tmp/htmlproofer.log
exit 0
