# Stage 1: Composer
FROM composer:latest AS vendor

WORKDIR /app
COPY . .
RUN composer install --no-dev --optimize-autoloader

# Stage 2: PHP Runtime
FROM php:8.2-cli

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    libpng-dev libonig-dev libxml2-dev zip unzip git curl

RUN docker-php-ext-install pdo pdo_mysql

COPY --from=vendor /app /var/www

RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 8000

CMD php artisan serve --host=0.0.0.0 --port=8000
