FROM ruby:3.3

WORKDIR /app

# Cache gems first (better layer reuse)
# - If Gemfile.lock exists, it will also be copied and used for deterministic installs.
# - If it doesn't, the image still builds (lock can be generated later).
COPY Gemfile* ./
RUN bundle config set path /usr/local/bundle \
  && bundle install --jobs 4 --retry 3

# App source (for production-like image usage; in dev we mount a volume)
COPY . .

EXPOSE 4000 35729

# Default: run dev server (can be overridden by docker-compose)
CMD ["bash", "-lc", "bundle exec jekyll s -l -H 0.0.0.0 -P 4000"]


