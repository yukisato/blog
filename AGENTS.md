# AGENTS.md

Minimal instructions for AI coding assistants working on this Jekyll blog.

## What this repo is

- **Type**: Personal tech blog (Jekyll + Chirpy)
- **Deploy**: GitHub Pages
- **Language**: Write posts and comments in **English**

## Content rules (posts)

- **Filename**: `_posts/YYYY-MM-DD-title-in-kebab-case.md`
- **Front matter**: include `title`, `date`, `categories`, `tags`, `description`
  - **Images**: If the post has an image, include `image.path` and `image.alt` in front matter. If no image, **omit the `image` section entirely** (do not include empty `image.path` or `image.alt` fields)
- **Timezone**: `date` must be **America/Vancouver** with numeric offset (`-0800` / `-0700`)

## Images

- Put post images under `assets/img/posts/YYYY-MM-DD-post-slug/`
- Always include meaningful **alt text**
- **If no image**: Do not include `image` fields in front matter (empty image fields cause htmlproofer errors)

## Text diagrams (ASCII)

- Use **ASCII characters only** (`+ - | > v` etc.). Avoid Unicode box-drawing characters (e.g., `┌─│└`) because they can render differently across devices.
- Keep lines **<= 40 characters wide** to reduce mobile layout issues.

## Local development

```bash
./tools/run.sh
./tools/run.sh -p
./tools/test.sh
```

### Bundler note (important)

Assume **Ruby/Bundler is NOT installed on the host**. Run bundler/jekyll commands via Docker Compose:

```bash
UID=$(id -u) GID=$(id -g) docker compose run --rm site bash -lc "bundle lock"
UID=$(id -u) GID=$(id -g) docker compose up --build
```

## Pre-commit validation

To automatically validate Jekyll builds before committing:

```bash
./scripts/install-hooks.sh
```

This installs a Git pre-commit hook that:
- Detects changes to `_posts/*.md` or config files
- Builds the site with `--future` flag (includes future-dated posts)
- Runs htmlproofer to catch link/image errors
- Blocks commit if validation fails

**Note**: The hook uses Docker Compose, so Docker must be running. To skip the hook (not recommended), use `git commit --no-verify`.

## Safety (before committing)

- Do not commit secrets, private info, or confidential data
- Sanitize screenshots (blur/redact as needed)

## When unsure

Ask for confirmation before making changes that are publicly visible or structural.

