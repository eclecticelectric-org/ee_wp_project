<?php
/*
 * local-config.php
 * Local wp-config file
 */

/* WP-CLI needs HTTP_HOST definition */
if ( defined( 'WP_CLI' ) && WP_CLI ) {
    $_SERVER['HTTP_HOST'] = 'host.local';
}

/**
 * WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
ini_set('display_errors', 'on');
define('WP_DEBUG_DISPLAY', true);
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', dirname(__FILE__) . '/logs/debug.log');

/* WP-CLI needs HTTP_HOST defined */
if (defined('WP_CLI') && WP_CLI) {
    $_SERVER['HTTP_HOST'] = 'host.local';
}

/* ========================
 * Custom Content Directory URL
 * !update for https!
 * ========================
 */
define( 'WP_CONTENT_URL', 'http://' . $_SERVER['HTTP_HOST'] . '/wp-content' );
// HTTPS version
// define( 'WP_CONTENT_URL', 'https://' . $_SERVER['HTTP_HOST'] . '/wp-content' );

/*
 *  DATABASE (MySQL) CONFIGURATION
 */

/* WordPress's MySQL database name */
define('DB_NAME', 'DATABASE_NAME');

/* MySQL database username */
define('DB_USER', 'DATABASE_USERNAME');

/* MySQL database password */
define('DB_PASSWORD', 'DATABASE_PASSWORD');

/* MySQL hostname */
define('DB_HOST', 'localhost');


/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
/*
define('AUTH_KEY',         'SET_THIS');
define('SECURE_AUTH_KEY',  'SET_THIS');
define('LOGGED_IN_KEY',    'SET_THIS');
define('NONCE_KEY',        'SET_THIS');
define('AUTH_SALT',        'SET_THIS');
define('SECURE_AUTH_SALT', 'SET_THIS');
define('LOGGED_IN_SALT',   'SET_THIS');
define('NONCE_SALT',       'SET_THIS');
 */
require 'salts.inc';
/**#@-*/

