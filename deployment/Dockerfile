FROM wordpress:latest

# Set environment variables for the cloud-based database
ENV DB_HOST jon
ENV DB_USER jon
ENV DB_PASSWORD qerty
ENV DB_NAME jons-db

# Copy the WordPress configuration file
COPY wp-config.php /var/www/html/

# Set file permissions for the WordPress configuration file
RUN chown www-data:www-data /var/www/html/wp-config.php