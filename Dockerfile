FROM ruby:3.0.1-alpine3.13
RUN apk add --no-cache \
    bash=5.1.0-r0 \
    build-base=0.5-r2 \
    curl=7.77.0-r1 && \
    mkdir /app

WORKDIR /app

# install gems in an stage prior to our source file(s) to make development iteration easier
COPY Gemfile Gemfile.lock /app/
RUN gem install bundler:2.2.21 && bundle install --jobs "$(nproc)"

COPY app/* /app
