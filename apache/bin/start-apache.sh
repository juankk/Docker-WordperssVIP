#!/usr/bin/env bash
#starting wordpress container
docker run --name wordpress-vip -e WORDPRESS_DB_PASSWORD=juan##3z -v $(pwd)/srv:/srv --link wordpress-mysql:mysql --link wordpress-memcache:memcache -p 80:80 -d wordpress-vip:latest