---
title: Testing GitHub Pages with Docker
description: This post explains how to test your GitHub Pages locally using docker.
tags:
  - github
  - docker
  - jekyll
---

This post explains how to check your blog's appearance for GitHub Pages using Docker.
Make sure if your site follows [Jekyll directory structure](https://jekyllrb.com/docs/structure/).

## Prerequisites

 - Have a GitHub Pages site
 - Your site follows the [Jekyll directory structure](https://jekyllrb.com/docs/structure/).
 - Docker environment

If your site is just a group of `.md` files, my previous post [How to apply and customize themes on GitHub Pages]({{ site.baseurl }}{% post_url /general/2021-07-15-how-to-apply-and-customize-themes-on-github-pages %}) might be your help.

## Take advantage of the docker image
Actually, Jekyll publishes [a special container for GitHub Pages](https://hub.docker.com/r/jekyll/jekyll/tags?page=1&ordering=last_updated&name=pages) tagged by `pages`, so this is the one for debugging your GitHub Pages.
It's better to create a serve script to DRY using `docker run` like this:

 ```bash
 #!/bin/bash

 docker run --rm -p 4000:4000 \
  -v "$PWD/docs:/srv/jekyll" \
  -it jekyll/jekyll:pages \
  jekyll serve --unpublished --future
```

 - `--unpublished` means you can see your drafts front mattered by `published: false`
 - `--future` means it renders future posts

To see more options, search in [Jekyll's documentation](https://jekyllrb.com/docs/configuration/options/#build-command-options).

All Done! Enjoy your site building! ;)
