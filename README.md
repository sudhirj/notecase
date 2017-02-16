# Notecase

Docs: http://docs.notecase.apiary.io

## Deployment

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Installation
```
git clone https://github.com/sudhirj/notecase.git
cd notecase
bundle install
bin/rake db:create:all
bin/rake db:migrate
```
And then 
```
bin/rails s
```
to run the server locally, or 
```
bundle exec guard 
```
to hack on the wallet itself and run tests continuously.

## Docker

If you have docker installed you can run notecase on Docker by using the following commands:
(Please make sure that you have updated the `.env` file with the necessary environment variable that you might need for the app to run)

```
docker-compose build
```
This would build the docker image

Create and migrate the databases using the commands:
```
docker-compose run app rake db:create
```
and
```
docker-compose run app rake db:migrate
```

and bring the app up by running:

```
docker-compose up -d
```
Now you can browse the app on the host on port 80 (http) or 443 (https if ssl is configured)
