# AGENTS.md

Instructions for AI coding assistants working on this Jekyll blog.

## Project Overview

This is a personal tech blog built with Jekyll using the Chirpy theme. The blog focuses on AI, automation, and software engineering topics.

- **Framework**: Jekyll 4.x with jekyll-theme-chirpy
- **Deployment**: GitHub Pages
- **Language**: All content and code comments should be in English

## Directory Structure

```
├── _posts/           # Blog posts (Markdown)
├── _drafts/          # Draft posts (not published)
├── _tabs/            # Navigation pages (About, Archives, etc.)
├── _data/            # Site configuration data
├── _includes/        # Custom template overrides
├── assets/
│   └── img/
│       ├── favicons/ # Site favicons
│       └── posts/    # Post-specific images
└── tools/            # Development scripts
```

## Writing Blog Posts

### File Naming Convention

Posts must follow Jekyll's naming convention:

```
_posts/YYYY-MM-DD-title-in-kebab-case.md
```

Example: `_posts/2025-01-15-building-ai-workflows-with-cursor.md`

### Front Matter Template

Every post should include:

```yaml
---
title: "Your Post Title"
date: YYYY-MM-DD HH:MM:SS -0800
categories: [Category, Subcategory]
tags: [tag1, tag2, tag3]
description: "A brief description for SEO and previews"
image:
  path: /assets/img/posts/YYYY-MM-DD-post-slug/cover.webp
  alt: "Image alt text for accessibility"
---
```

**Timezone note**: Write `date` in **America/Vancouver** time and include the numeric offset (e.g. `-0800` / `-0700` depending on DST).

### Categories

Current categories (expand as needed):

- `AI` — Artificial intelligence and machine learning
- `Automation` — Workflow automation and productivity

### Image Management

Store images in a dedicated folder per post:

```
assets/img/posts/YYYY-MM-DD-post-slug/
├── cover.webp       # Featured image (1200x630px recommended)
├── screenshot-1.webp
└── diagram.svg
```

Reference in posts:

```markdown
![Alt text](/assets/img/posts/2025-01-15-post-slug/image.webp)
```

## Code Style & Quality

### Markdown

- Use ATX-style headers (`#`, `##`, `###`)
- Add blank lines before and after code blocks
- Use fenced code blocks with language identifiers
- Prefer reference-style links for repeated URLs

### Code Blocks

Always specify the language for syntax highlighting:

````markdown
```python
def example():
    pass
```
````

## Git Workflow

### Branch Strategy

This is a personal blog. Commit directly to `main` for simplicity.

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

| Type       | Description                          |
|------------|--------------------------------------|
| `feat:`    | New feature or blog post             |
| `fix:`     | Bug fix or content correction        |
| `docs:`    | Documentation updates                |
| `style:`   | Formatting, no code change           |
| `refactor:`| Code restructuring                   |
| `chore:`   | Maintenance tasks                    |

Examples:

```
feat: add post about AI workflow automation
fix: correct typo in about page
docs: update AGENTS.md with image guidelines
chore: update dependencies
```

## Development Commands

```bash
# Start local development server
./tools/run.sh

# Start in production mode
./tools/run.sh -p

# Run HTML validation tests
./tools/test.sh

# Manual Jekyll serve (alternative)
bundle exec jekyll serve
```

## Security & Privacy Guidelines

### Before Publishing

**Always verify the following before committing:**

1. **No Sensitive Information**
   - API keys, tokens, or credentials
   - Internal URLs or IP addresses
   - Personal information (addresses, phone numbers)
   - Client or employer confidential data

2. **Image Privacy**
   - Blur or redact sensitive information in screenshots
   - Remove EXIF metadata from photos if location data is present
   - Verify no unintended personal information is visible

3. **Code Samples**
   - Use placeholder values: `YOUR_API_KEY`, `example.com`
   - Anonymize real data in examples
   - Verify copied code doesn't contain hardcoded secrets

### If Uncertain

If content might contain sensitive information, **stop and ask for confirmation** before proceeding. It's better to verify than to accidentally expose private data.

## SEO & Accessibility

### SEO Best Practices

- Write descriptive titles (50-60 characters)
- Include meta descriptions (150-160 characters)
- Use descriptive alt text for all images
- Structure content with proper heading hierarchy

### Accessibility

- All images must have meaningful `alt` attributes
- Use descriptive link text (avoid "click here")
- Ensure sufficient color contrast in custom styles
- Use semantic HTML in custom includes

## Performance Considerations

- Optimize images before adding (compress PNG/JPEG, prefer WebP/SVG)
- Keep featured images under 200KB
- Minimize custom JavaScript

## Updating the Site

### Adding a New Post

1. Create file: `_posts/YYYY-MM-DD-title.md`
2. Add front matter with required fields
3. Write content in Markdown
4. Add images to `assets/img/posts/YYYY-MM-DD-title/`
5. Preview locally with `./tools/run.sh`
6. Commit and push to deploy

### Modifying Theme Elements

Custom overrides go in `_includes/`. Currently overridden:

- `footer.html` — Custom footer without theme attribution

To override other theme files, copy from the gem:

```bash
bundle info --path jekyll-theme-chirpy
```

## Questions & Clarifications

When working on this project, if requirements are unclear or multiple valid approaches exist, ask for clarification before proceeding. Prefer explicit confirmation over assumptions for:

- Content that will be publicly visible
- Changes to site configuration
- Structural changes to the project

