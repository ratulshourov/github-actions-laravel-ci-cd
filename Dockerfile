FROM php:8.2-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev \
    nginx

RUN docker-php-ext-install pdo pdo_mysql

# composer copy
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

RUN composer install --no-dev --optimize-autoloader

# permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# expose port
EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=10000
