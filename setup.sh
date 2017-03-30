#!/bin/bash

trap 'error' ERR

error() {
  echo "There was a problem starting Woof."
}

source .env

validation() {
  : "${MYSQL_ROOT_PASSWORD:?MYSQL_ROOT_PASSWORD needs to be set}"
  : "${MYSQL_DATABASE:?MYSQL_DATABASE needs to be set}"
  : "${MYSQL_USER:?MYSQL_USER needs to be set}"
  : "${MYSQL_PASSWORD:?MYSQL_PASSWORD needs to be set}"
  : "${DB_USER:?DB_USER needs to be set}"
  
  : "${DB_NAME:?DB_NAME needs to be set}"
  : "${DB_PASSWORD:?DB_PASSWORD needs to be set}"
  : "${DB_HOST:?DB_HOST needs to be set}"
}

docker-compose up -d db # spin up mysql

docker-compose build app

docker-compose run --rm app rake db:create db:migrate

docker-compose up -d app # spin up woof