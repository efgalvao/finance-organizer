FROM ruby:3.0-alpine AS builder
RUN apk add \
  build-base \
  postgresql-dev
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
  FROM ruby:3.0-alpine AS runner
RUN apk add \
    tzdata \
    nodejs \
    postgresql-dev
WORKDIR /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
