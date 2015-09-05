#!/usr/bin/env bash
#removing image to be able to rebuild it
docker rmi wordpress-vip

#building wordpress vip apache
docker build -t wordpress-vip:latest .

sh bin/start-core.sh
sh bin/start-apache.sh