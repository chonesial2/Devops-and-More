FROM php:7.4-apache

RUN apt update
RUN apt install wget

WORKDIR /tmp
RUN wget https://github.com/elastic/apm-agent-php/releases/download/v1.5.2/apm-agent-php_1.5.2_all.deb
RUN dpkg -i ./apm-agent-php_1.5.2_all.deb

WORKDIR /var/www/html


