---
title: How to make your GitHub Pages fancy
---

This post is for those who write markdown files for GitHub Pages and want to make its appearance better. 

You might know that the GitHub Pages is backended by Jekyll static site generator.
This means you can theme/configure your site as thought your group of markdown files is a Jekyll site.

## Difference between GitHub Pages and Jekyll

The difference between Jekyll and GitHub Pages is configuration and installation.
With using GitHub Pages, you implicitly omitted these processes to build your site:

 - Jekyll installation
 - Jekyll configuration
 - CI/CD for generating HTML files

Of cause you can expricitly do these process to buiuld your site, but, the more you work on those processes, the less advantages of GitHub you make use of.
Thus the point is to add just a small change for better appearance.

## Change appearance in one change

GitHub pages supports several Jekyll themes. To enalbe it, add a config file `_config.yml` under your document's root directory with just one line. Pick up one of [their supported themes](https://pages.github.com/themes/) and make this config file.

```yaml
theme: hacker
```

Once you commit your own config file, you'll see the difference(it might take a few minutes).

By the way, they listed `minima` in the list but it's actually not supported now.
If you loved `minima` theme and really want to use it, set a keyword `remote_theme` specifying its GitHub repository instead:

```yaml
# _config.yml
remote_theme: jekyll/minima
```

After you apply this configuration, you'll realize that this site is actually built with this theme :)
