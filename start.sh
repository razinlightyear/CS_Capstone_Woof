#!/bin/bash

trap 'error' ERR

error() {
  echo "There was a problem starting Woof."
}

docker start woof_app_1

docker start woof_db_1

echo "Woof environment should be started."