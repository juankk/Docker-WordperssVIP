#!/usr/bin/env bash

docker stop wordpress-vip
docker rm wordpress-vip
rm -rf srv/www
docker rmi wordpress-vip
docker build -t wordpress-vip:latest .
sh bin/start-apache.sh
docker logs -f wordpress-vip