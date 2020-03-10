<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

ini_set('display_errors', 'off');

/*
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

// ===================================================
// Load database info and local development parameters
//  ===================================================
if (file_exists( dirname( __FILE__ ) . '/../production-config.php' ) ) {
    define( 'WP_LOCAL_DEV', false );
    include( dirname( __FILE__ ) . '/../production-config.php' );
} else {
    define( 'WP_LOCAL_DEV', true );
    include( dirname( __FILE__ ) . '/../local-config.php' );
}

/* ========================
 * Custom Content Directory
 * Modify WP_CONTENT_URL in local/production config
 * ========================
 */
define( 'WP_CONTENT_DIR', dirname( __FILE__ ) . '/wp-content' );
if (!defined('WP_CONTENT_URL')) {
    define( 'WP_CONTENT_URL', 'http://' . $_SERVER['HTTP_HOST'] . '/wp-content' );
}

/*
 * DATABASE configuration
 */
/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/*
 * Disable automatic updates
 */
define('AUTOMATIC_UPDATER_DISABLED', true);

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');

/* That's all, stop editing! Happy blogging. */

// ----- end of wp-config.php -----
