#!/bin/bash

docker run --rm -p 4000:4000 \
  --volume="$PWD/docs:/srv/jekyll" \
  -it jekyll/jekyll:pages \
  jekyll serve --unpublished --future