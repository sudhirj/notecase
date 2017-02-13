# Notecase

Docs: http://docs.notecase.apiary.io

## Installation
```
git clone https://github.com/RealImage/qw-notecase.git
cd qw-notecase
bundle install
rake db:create:all
rake db:migrate
```
And then 
```
rails s -p 3003 -b 0.0.0.0
```
to run the server locally, or 
```
bundle exec guard 
```
to hack on the wallet itself and run tests continuously.

To run the application in docker, execute the command

```
docker build -t qw-notecase:0.1 --build-arg QWP_WALLET_TOKEN=<token-secret> --build-arg QWP_DB_USERNAME=<db user name> --build-arg QWP_DB_PASSWORD=<database user password> --build-arg QWP_DB_HOST=<db host> --build-arg QWP_DB_PORT=<db port> --build-arg QWP_DB_NAME=<db name> --build-arg QWP_RAILS_ENV=<environment name (should be development/test/production)> .
```
and then 
 ```
docker run -p 3003:3003 -t qw-notecase:0.1
```

The wallet srvice will now be reachable in port 3003

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
