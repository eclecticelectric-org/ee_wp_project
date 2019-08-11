# WordPress Project Template using Composer and Git

[![License: GPL v3](https://img.shields.io/badge/license-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

Eclectic Electric created this WordPress project template to give website developers and web agencies a useful tool for building secure and easily managed client WordPress websites. The project uses the [Composer](https://getcomposer.org/) package manager, [WPackagist](https://wpackagist.org/) plugin repository, and Git as key tools in the process.

This guide is for a *new* project installation in a cloud hosting environment where the installer has `sudo` access. For information about updating an existing project that uses this template, read more on the project [Building an Advanced WordPress Project using Composer and Git](BUILD.md) page.

#### Key Features & Benefits:
* WordPress core, theme, and plugin updates managed with [Composer](https://getcomposer.org/)
* Manage and protect website code with [GitHub](https://github.com/), [GitLab](https://about.gitlab.com/), or other Git repository
* WordPress configuration files stored outside of web accessible files
* Separate WordPress configuration for development and production
* Limited web server write permissions to enhance security and protect against hacks
* Enhanced security through configurable file and directory permissions
* Simplifies installing on a development server and migrating to production
* `WP_CONTENT_DIR` and `WP_CONTENT_URL` directories are stored outside of the WordPress directory to simplify managing user content and *Composer* compatibility
* Test updates and enhancements in development before pushing to production with *git* and *composer*
* Project repository only holds files not available through an authoritative source, significantly reducing the size of the reposotiry and eliminating noise creatred by changes to WordPress core and plugins
* Purchased (proprietary) themes and plugins stored in the repository

## Quick Start Guide

Eclectic's WordPress project template has the following software requirements:

*Requirements*
* Linux Ubuntu 18.04 LTS or later
* Apache 2.4+ or nginx 1.9+ web server
* [WordPress LAMP or LEMP stack](https://wordpress.org/about/requirements/)
* Git
* [Composer](https://getcomposer.org/)
* `sudo` access

*Optional (but highly recommended!)*
* [wp-cli](https://wp-cli.org/)

This guide provides instructions for an initial install. Refer to [Building an Advanced WordPress Project Using Composer and Git](BUILD.md) for instructions on building a project built from this template.

> *For our examples, we'll use **spacelaunch** as the PROJECT and **spacelaunch.com** for the website DOMAIN.*

#### Create a MySQL database for WordPress

Create an empty MySQL database to be used by WordPress. Create a MySQL user with all permissions on tha new database. Here are sample commands for a new database **wp_spacelaunch** and user **djones** with password **nosecret**. 

```
$ mysql -u root -p
mysql> CREATE DATABASE wp_spacelaunch DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
mysql> GRANT ALL ON wp_spacelaunch.* TO 'djones'@'localhost' IDENTIFIED BY 'nosecret';
mysql> FLUSH PRIVILEGES;
mysql> EXIT;
```
#### Clone the Remote Repository to a Local Project Directory

Change to a directory under your user account, the system web host directorym (such as /var/www), or another directory of your choice. Regardless of the directory you choose as the parent directory of your project, you need full access permissions using your user account or through the use of *sudo*.

Clone the remote repository:

    $ git clone https://github.com/eclecticelectric-org/ee_wp_project.git spacelaunch
    
#### Run the Configuration Script

Run the setup script with the following command:

    $ spacelaunch/setup/ee-wordpress-setup.sh -p spacelaunch -d spacelaunch.com

The configuration script usage guide (``ee-wordpress-setup.sh --help``) describes required and optional arguments that let you tailor the project initialization to your project and environment.

```
Usage: ee-wordpress-setup.sh  --project-domain DOMAIN [OPTION]...
Initialize a WordPress project

Required:
  -d, --project-domain DOMAIN   domain name (example.com)

Options:
  -h, --help                    display this usage information and exit
  -p, --project PROJECT         project name (match cloned repository directory name)
                                  (if not provided, defaults to --project-domain value)
  -w, --web-user USER           web server process user (www-data)
  -b, --web-group GROUP         web server process user group (www-data)
  -r, --web-root DIRECTORY      parent filesystem directory for project
  -s, --web-server              config virtual host: [apache|nginx] (apache)
  -u, --user USER               user owner of project files
  -g, --group GROUP             group owner of project files
  -c, --host-config DIRECTORY   host config directory (/etc/apache2/sites-available)
  -k, --keep-git                keep cloned project's .git directory

Examples:
   ee-wordpress-setup.sh -p spacelaunch.com
   ee-wordpress-setup.sh -p spacelaunch -d spacelaunch.com
   ee-wordpress-setup.sh -p spacelaunch -d spacelaunch.com -u webdev -g webdev
   ee-wordpress-setup.sh -p spacelaunch -d spacelaunch.com -s nginx
```
> *Provide your \'sudo\' credentials if prompted. The default configuration sets permissions that allow WordPress to create and edit files in the `wp-content/uploads` directory.*

> *The configuration script removes execute permissions from scripts in the project `setup\` directory to ensure they can't be run a second time with unintended consequences!*

#### Final Configuration Steps

1. Edit the file `PROJECT/local-config.php` and add values for these three database variables
    * DB_NAME
    * DB_USER
    * DB_PASSWORD

*Edit values in local-config.php, replacing DATABASE_NAME, DATABASE_USERNAME, and DATABASE_PASSWORD:*
```
/** The name of the database for WordPress */
define('DB_NAME', 'DATABASE_NAME');

/** MySQL database username */
define('DB_USER', 'DATABASE_USERNAME');

/** MySQL database password */
define('DB_PASSWORD', 'DATABASE_PASSWORD');
```
2. Create a DNS record for the project domain (in our examples we used **spacelaunch.com**) and assign to it the value of the host server's public IP address.

3. Enable the new website in Apache
```
    $ sudo a2ensite spacelaunch.com
```
4. Reload the web server configuration and give it a go!
```
    $ sudo systemctl restart apache2  # Ubuntu 18.04 LTS
```
Visit your project URL \(http://spacelaunch.com for our example\) and you should see the familiar WordPress installation screen.

#### Additional Notes

* After a WordPress core update using *Composer*, copy `/apache/wp_htaccess_default` to `/public/wp/.htaccess` (This will be handled automatically in the future)
* Use of the -k (keep .git workspace) option removes the definition of 'origin' which must be defined prior to pusing to a new repository

## Advanced WordPress Project Layout

* / (project root)
  * composer.json
  * composer.lock *(maintained by Composer)*
  * local-config.php *(or production-config.php)*
  * public / (web server docroot)
    * index.php
    * wp / *(WordPress core)*
    * wp-config.php
    * wp-content /
      * uploads /
      * themes /
      * plugins /
  * vendor / *(maintained by Composer)*
  * apache / *(Apache sample files)*
    * `example.conf` *(copy to Apache virtual host directory)*
    * `wp_htaccess_default` *(copy to `/public/wp/.htaccess`)*
  * nginx / *(nginx sample file)*
    * `example.conf` *(copy to nginx virtual host directory)*
  * setup / (setup scripts)
    * `wp_local_config.sh` *(support script)*
    * `ee-wordpress-setup.sh` *(main setup script)*
  * .gitignore
  * .git /

#### References

Thanks to the following sites which provided inspiration and information!

[John P Bloch WordPress core installer](https://github.com/johnpbloch/wordpress-core-installer)

[WordPress Packagist](https://wpackagist.org/)

[Composer](https://getcomposer.org/)

---

*Background information, some of which may include conflicting information!*

[How to Install the WP-CLI command line tookkit](https://make.wordpress.org/cli/handbook/installing/)

[Managing WordPress Sites with Git and Composer](https://deliciousbrains.com/storing-wordpress-in-git/)

[A WordPress Development Workflow for Small Teams in 2015](https://zackphilipps.com/a-wordpress-development-workflow-for-small-teams-in-2015/)

[Moving WordPress](https://codex.wordpress.org/Moving_WordPress)

[Keeping WordPress Under Version Control with Git](https://stevegrunwell.com/blog/keeping-wordpress-under-version-control-with-git/)

[nginx WordPress Recipe](https://www.nginx.com/resources/wiki/start/topics/recipes/wordpress/)

*WordPress is a registered trademark of Automattic Inc.*

~
