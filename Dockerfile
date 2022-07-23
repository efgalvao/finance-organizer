FROM ruby:3.0.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev npm

RUN mkdir /app
WORKDIR /app

COPY Gemfile ./
COPY Gemfile.lock ./

RUN npm install -g yarn

RUN bundle install

RUN rake webpacker:install

COPY . .
