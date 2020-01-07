FROM php:7.4-apache
ENV APACHE_DOCUMENT_ROOT=/var/www/html/www
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# git
RUN apt-get update && apt-get install -y git
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
        libxml2-dev \
        libzip-dev \
        libonig-dev \
        sendmail \
        graphviz

RUN docker-php-ext-install pdo pdo_mysql mysqli && docker-php-ext-enable pdo_mysql
RUN a2enmod rewrite

RUN docker-php-ext-install mbstring
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd

# xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . /var/www/html/

# addrs
RUN mkdir -p /var/www/html/application/cache
RUN chown www-data:www-data /var/www/html/application/cache

RUN mkdir -p /var/www/html/application/logs
RUN chown www-data:www-data /var/www/html/application/logs

#RUN composer update
#RUN composer install

EXPOSE 80
EXPOSE 3306

