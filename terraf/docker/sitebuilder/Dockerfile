FROM ubuntu:bionic as base

WORKDIR /app

# Install wget, unzip
RUN apt-get -y update && \
    apt-get -y install  wget \
                        unzip

# Download and install ionCube Loader
RUN wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.zip && \
    unzip ioncube_loaders_lin_x86-64.zip && \
    rm ioncube_loaders_lin_x86-64.zip

## Download and extract Site Builder archive
RUN wget https://update.site.pro/_installer/builder/SitePro_Builder_v4_php71.tar.gz && \
    mkdir sitebuilder && \
    tar -xzf SitePro_Builder_v4_php71.tar.gz -C sitebuilder && \
    rm SitePro_Builder_v4_php71.tar.gz

FROM php:7.4-apache

# Install libraries for php extentions
RUN apt-get -y update && \
    apt-get -y install  libzip-dev \
                        libgd-dev

# Remove apt cache
RUN rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Install required php extensions
RUN docker-php-ext-install  zip \
                            gd  \
                            pdo_mysql

# Setup ionCube Loader
COPY --from=base /app/ioncube/ /usr/local/lib/php/extensions/ioncube/

# Configure ionCube Loader
RUN echo "zend_extension = /usr/local/lib/php/extensions/ioncube/ioncube_loader_lin_7.4.so" > /usr/local/etc/php/php.ini

## Setup Site Builder
# Open - http://<domain>/installer/
WORKDIR /var/www/html
COPY --from=base /app/sitebuilder/ /var/www/html/

# Configure PHP settings
RUN echo -n "post_max_size	= 256M \nupload_max_filesize = 256M \nmemory_limit = 1024M \n" >> /usr/local/etc/php/php.ini

# Enable rewrite module
RUN a2enmod rewrite
