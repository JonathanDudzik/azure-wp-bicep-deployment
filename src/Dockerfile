FROM wordpress:latest

# Set environment variables for the cloud-based database
ENV DB_NAME=${DB_NAME}
ENV DB_USER=${DB_USER}
ENV DB_PASSWORD=${DB_PASSWORD}
ENV DB_HOST=${DB_HOST}

# Copy the WordPress configuration file
COPY wp-config.php /var/www/html/

# Set file permissions for the WordPress configuration file
RUN chown www-data:www-data /var/www/html/wp-config.php