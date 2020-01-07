# Base image.
ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-fpm-alpine

# Install essential softwares.
RUN apk add --no-cache \
        git \
        nano \
        npm \
        sqlite \
        supervisor \
        tzdata

# Install PHP Core extensions.
RUN apk add --no-cache \
        aspell-dev \
        bzip2-dev \
        freetype-dev \
        icu-dev \
        imap-dev \
        libgcrypt-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libxml2-dev \
        libxslt-dev \
        libzip-dev \
        postgresql-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        bz2 \
        calendar \
        exif \
        gd \
        imap \
        intl \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        pspell \
        soap \
        sockets \
        xsl \
        zip \
    && apk del \
        bzip2-dev

# Install PHP PECL extensions.
RUN apk add --no-cache \
        $PHPIZE_DEPS \
        imagemagick-dev \
        libmcrypt-dev \
        libmemcached-dev \
        rabbitmq-c-dev \
    && pecl install \
        amqp \
        igbinary \
        imagick \
        mcrypt \
        msgpack \
        memcached \
        redis \
        timezonedb \
        xdebug \
    && docker-php-ext-enable \
        amqp \
        igbinary \
        imagick \
        mcrypt \
        msgpack \
        memcached \
        redis \
        timezonedb \
        xdebug \
    && apk del \
        $PHPIZE_DEPS

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add composer bin directory into PATH.
ENV PATH="/root/.composer/vendor/bin:${PATH}"

# Install global composer packages.
RUN composer global require \
        laravel/installer \
        laravel/envoy \
        wp-coding-standards/wpcs \
    && phpcs --config-set installed_paths /root/.composer/vendor/wp-coding-standards/wpcs

# Install ssh client
RUN apk add --no-cache openssh-client \
    && ssh-keygen -t rsa -b 4096 -C "root@`hostname -s`" -f /root/.ssh/id_rsa -q -N ""

# Remove base image generated web directory.
RUN rm -rf /var/www

# Change working directory.
WORKDIR /srv/www

# Copy entrypoint file.
COPY start.sh /usr/local/bin/

# Make entrypoint file executable.
RUN chmod +x /usr/local/bin/start.sh

# Set entrypoint.
ENTRYPOINT [ "start.sh" ]

# Set command.
CMD [ "supervisord", "-u", "root", "-c", "/etc/supervisord.conf", "-n" ]
