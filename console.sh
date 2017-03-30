#!/bin/bash

docker exec -ti $(sudo docker ps -aqf "name=woof_app") rails console