FROM php:7.2-apache

COPY src/ /var/www/html

RUN apt-get update && apt-get install -y \
    build-essential \
    librabbitmq-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# IMG Extension
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

# MySQL extension
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN docker-php-ext-enable mysqli

# Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Amqp extension
RUN pecl install amqp && docker-php-ext-enable amqp

# Grpc extension
RUN pecl install grpc && docker-php-ext-enable grpc

RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite && service apache2 restart
