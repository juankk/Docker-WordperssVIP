FROM php:5.4-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev \
	libjpeg-dev \
	git subversion \
	curl \
	libc6 \
	libcurl3 \
	zlib1g \
	clamav \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd

RUN docker-php-ext-install mysqli
RUN pecl install memcache
RUN docker-php-ext-enable memcache

VOLUME /srv

COPY init-tables.sql /init-tables.sql

COPY docker-entrypoint.sh /entrypoint.sh

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/entrypoint.sh"]

#installing wp cli
WORKDIR /tmp
CMD ["curl", "-O", "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"]
CMD ["php", "wp-cli.phar", "--info"]
CMD ["chmod", "+x", "wp-cli.phar"]
CMD ["mv", "wp-cli.phar", "/usr/local/bin/wp"]

CMD ["apache2-foreground"]
