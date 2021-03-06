<?php
/*
 * local-config.php
 * Local wp-config file
 */

/* WP-CLI needs HTTP_HOST definition */
if ( defined( 'WP_CLI' ) && WP_CLI ) {
    $_SERVER['HTTP_HOST'] = '';
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
ini_set( 'display_errors', 'on' );
define( 'WP_DEBUG_DISPLAY', true );
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );

/**
 * set the WordPress memory limit
 */
define( 'WP_MEMORY_LIMIT', '64M' );

/* ========================
 * Custom Content Directory URL
 * ========================
 */
$http_request_scheme = 'http';
if ((isset($_SERVER['HTTPS']) && (strtolower($_SERVER['HTTPS']) === 'on')) ||
    (isset($_SERVER['REQUEST_SCHEME']) && (strtolower($_SERVER['REQUEST_SCHEME']) === 'https'))) {
    $http_request_scheme = 'https';
}
define( 'WP_CONTENT_URL', $http_request_scheme . '://' . $_SERVER['HTTP_HOST'] . '/wp-content' );

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

/*
 * turn off post revisions
 */
define('WP_POST_REVISIONS', false);
/* disable plugin and theme update and installation from WP admin console */
define( 'DISALLOW_FILE_MODS', true );
/* disable all core auto updates */
define( 'WP_AUTO_UPDATE_CORE', false );

// ----- end of config file -----
