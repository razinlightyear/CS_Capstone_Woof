#!/bin/bash

trap 'error' ERR

error() {
  echo "There was a problem stopping Woof."
}

docker stop woof_app_1

docker stop woof_db_1

echo "Woof environment should be stopped."