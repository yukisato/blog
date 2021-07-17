#!/bin/bash

docker run --rm -p 4000:4000 \
  -v "$PWD/docs:/srv/jekyll" \
  -it jekyll/jekyll:pages \
  jekyll serve --unpublished --future
