FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql mysqli zip mbstring curl xml bcmath

# Enable Apache modules
RUN a2enmod rewrite headers

# Set working directory
WORKDIR /var/www/html

# Copy the application code
COPY ./lhc_web /var/www/html

# Ensure permissions and create missing directories
RUN mkdir -p /var/www/html/cache \
    /var/www/html/var/userphoto \
    /var/www/html/var/storagemms \
    /var/www/html/var/storagev2 \
    /var/www/html/var/storage \
    /var/www/html/var/tmpfiles \
    /var/www/html/var/tcpdf \
    /var/www/html/settings \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/cache \
    && chmod -R 755 /var/www/html/var \
    && chmod -R 755 /var/www/html/settings

EXPOSE 80

CMD ["apache2-foreground"]

