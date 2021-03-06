---
title: How to apply and customize themes on GitHub Pages
description: This post explains how to make your GitHub Pages look better. 
tags:
  - github
  - jekyll
---

This post is for those who write markdown files for GitHub Pages and want to make its appearance better. 

You might know that the GitHub Pages is backended by Jekyll static site generator.
This means you can theme/configure your site as though your group of markdown files is a Jekyll site.

## Difference between GitHub Pages and Jekyll

The difference between Jekyll and GitHub Pages is configuration and installation.
By using GitHub Pages, you implicitly omitted these processes to build your site:

 - Jekyll installation
 - Jekyll configuration
 - CI/CD for generating HTML files

Of cause you can explicitly do these processes to build your site, but, the more you work on those processes, the fewer advantages of GitHub you make use of.
Thus the point is to add just a small change for a better appearance.

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

## More customizations

If you want to more customize your pages like a blog site, you literally need to make your repository a Jekyll site.
Fortunately, as described above, GitHub Pages is backended by Jekyll so we don't have to install Jekyll itself and all files of the theme you applied. But there still be something to do.

Here's basic instruction to change your pages into a Jekyll site:

 - Move your files into `_posts` directory
 - Rename your files to `YYYY-MM-DD-*.md` prefixed by date
 - Write [front matter](https://jekyllrb.com/docs/front-matter/) on top of each file
 - Add more your site's information in `_config.yml`. See (Jekyll configuration document](https://jekyllrb.com/docs/configuration/)
 - Add `index.md` if there isn't. Take a look at your theme's one for reference

After these setups, you'll stick on `_config.yml` for more customization.
As many themes have their own configurations for their design and features, you can also add theme-specific configurations in this setting file.

For instance, if you use `minima` theme and want to change date format in blog posts, you can specify it with the following configuration(see [minima's docs](https://github.com/jekyll/minima#skins)):

```yaml
minima:
  date_format: "%b %-d, %Y"
```

That's all! If you want to test your site locally, also see my post [Testing GitHub Pages with Docker]({{ site.baseurl }}{% post_url /general/2021-07-16-testing-github-pages-with-docker %}).

Hope you enjoyed my post and can make your blog better ;)
