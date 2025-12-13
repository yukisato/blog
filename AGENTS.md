# AGENTS.md

Minimal instructions for AI coding assistants working on this Jekyll blog.

## What this repo is

- **Type**: Personal tech blog (Jekyll + Chirpy)
- **Deploy**: GitHub Pages
- **Language**: Write posts and comments in **English**

## Content rules (posts)

- **Filename**: `_posts/YYYY-MM-DD-title-in-kebab-case.md`
- **Front matter**: include `title`, `date`, `categories`, `tags`, `description`, `image.path`, `image.alt`
- **Timezone**: `date` must be **America/Vancouver** with numeric offset (`-0800` / `-0700`)

## Images

- Put post images under `assets/img/posts/YYYY-MM-DD-post-slug/`
- Always include meaningful **alt text**

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

## Safety (before committing)

- Do not commit secrets, private info, or confidential data
- Sanitize screenshots (blur/redact as needed)

## When unsure

Ask for confirmation before making changes that are publicly visible or structural.

