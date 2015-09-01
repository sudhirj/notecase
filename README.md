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
