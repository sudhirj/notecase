FROM ruby:2.3.0-slim

ENV RAILS_ROOT /var/www/docker

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client && mkdir -p $RAILS_ROOT/tmp/pids

WORKDIR $RAILS_ROOT

COPY . .

RUN gem install bundler && bundle install

CMD [ "config/containers/app_cmd.sh" ]