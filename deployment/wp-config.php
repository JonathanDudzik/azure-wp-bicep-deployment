<?php

// Database connection settings
define('DB_NAME', $_ENV['DB_NAME']);
define('DB_USER', $_ENV['DB_USER']);
define('DB_PASSWORD', $_ENV['DB_PASSWORD']);
define('DB_HOST', $_ENV['DB_HOST']);
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// Authentication unique keys and salts
define('AUTH_KEY',         '<random_string>');
define('SECURE_AUTH_KEY',  '<random_string>');
define('LOGGED_IN_KEY',    '<random_string>');
define('NONCE_KEY',        '<random_string>');
define('AUTH_SALT',        '<random_string>');
define('SECURE_AUTH_SALT', '<random_string>');
define('LOGGED_IN_SALT',   '<random_string>');
define('NONCE_SALT',       '<random_string>');

// WordPress table prefix
$table_prefix  = 'wp_';

// Debug mode
define('WP_DEBUG', false);

// Disable file editing from the WordPress dashboard
define('DISALLOW_FILE_EDIT', true);

// Disable WordPress updates
define('AUTOMATIC_UPDATER_DISABLED', true);

// Set the filesystem method to "direct" to allow WordPress to write to the filesystem
define('FS_METHOD', 'direct');

// Set the uploads directory to a writable location
define('UPLOADS', 'wp-content/uploads');
