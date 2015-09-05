#!/usr/bin/env bash
#starting mysql container
docker run --name wordpress-mysql -e MYSQL_ROOT_PASSWORD=juan##3z -v $(pwd)/database:/database -p 33066:3306 -d mysql:latest

#starting memcache
docker run --name wordpress-memcache -d memcached memcached -m 64