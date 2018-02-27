FROM ruby:2.3.0-slim

ENV RAILS_ROOT /var/www/docker

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client && mkdir -p $RAILS_ROOT/tmp/pids

WORKDIR $RAILS_ROOT

COPY . .

RUN gem install bundler && bundle install

EXPOSE 5000
ENTRYPOINT RAILS_ENV=production bundle exec unicorn -p 5000 -c ./config/unicorn.rb
