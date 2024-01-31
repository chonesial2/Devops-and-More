FROM php:7.4-alpine

# Download and install apm-agent for php app
WORKDIR /tmp
RUN wget https://github.com/elastic/apm-agent-php/releases/download/v1.5.2/apm-agent-php_1.5.2_all.apk
RUN apk add --allow-untrusted ./apm-agent-php_1.5.2_all.apk

WORKDIR /var/www/html

EXPOSE 80

# Run php app
CMD ["php", "-S", "0.0.0.0:80", "-t", "/var/www/html"]
