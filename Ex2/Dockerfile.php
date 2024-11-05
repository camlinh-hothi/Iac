FROM php:7.4-fpm

# Installer l'extension mysqli
RUN docker-php-ext-install mysqli

# Copier les fichiers source PHP dans le container
COPY src/ /var/www/html
