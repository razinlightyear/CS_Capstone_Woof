#!/bin/bash

docker exec -ti $(sudo docker ps -aqf "name=woof_app") tail -f log/development.log