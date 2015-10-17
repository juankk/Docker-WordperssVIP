FROM php:5.6-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev \
	libjpeg-dev \
	git \
	subversion \
	curl \
	libc6 \
	libcurl3 \
	zlib1g \
	clamav \
	mysql-client \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd

RUN docker-php-ext-install mysqli
RUN pecl install memcache
RUN docker-php-ext-enable memcache

VOLUME /var/www/html

COPY init-tables.sql /init-tables.sql
COPY files /files

COPY docker-entrypoint.sh /entrypoint.sh

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]
