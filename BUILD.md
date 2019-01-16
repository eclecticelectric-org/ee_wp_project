# Building an Advanced WordPress Project using Composer and Git
 
Once a project based upon Eclectic Electric's WordPress Project Template is installed and running, use [Composer](https://getcomposer.org/) and [Git](https://git-scm.com/doc) to build upon the initital installation. To read about creating a new project, visit [Advanced WordPress Project Management using Composer and Git](README.md).

## Introduction

The project template uses public authoritative package repositories to install and update WordPress core, plugins, and themes available through WordPress.org. Storing code updates for externally maintained packages and code bases clutters the repository with information not specific to the project.

Composer excels at managing code dependencies. Two public code repositories, [WordPress.org](https://wordpress.org/plugins/) and [WordPress Packagist](https://wpackagist.org/) provide the authoritative code Composer uses for updates. Git manages souce code changes. Together, these tools simplify core, plugin and theme management and provide a framework that promotes process and efficiency.

*NOTE: All Composer commands should be run from the project `/public` folder.*

#### Workflow

The project development workflow is engineered for making and testing changes in a staging environment and not on a production server. Code modifications and enhancements are completed and tested in staging, committed to the Git repository, and then installed on the production server. Repeat!

Here is the worklow in more detail:

*On the STAGING server*

* Checkout the latest release (git)
* Migrate a copy of the production database to staging
* Update WordPress core and update/add plugins and themes (composer)
* (optional) Manually update/add purchased plugins and themes
* Test!
* Commit changes to the repository and tag a release (git)

*On the PRODUCTION server*

* Use Git to checkout the new release to the production server
* Use Composer to install the correct versions of WordPress core and plugins


#### Importance of the Project .gitignore

The `.gitignore` file located in the project root directory is configured so Composer managed packages are not included in the code repository. If a purchased package doesn't offer a Composer package repository the project `.gitignore` file must be updated to include the purchased plugin or theme in the project Git repository. Section **Adding Purchased Plugins and Themes** includes examples of modifying the `.gitignore` to include a purchased theme or plugin that doesn't offer Composer support.


## Adding New Plugins and Themes

Composer can manage plugins and themes available on WordPress.Org. Unfortunately, most purchased plugins and themes are not available in a package compatible with Composer and so they must be handled manually. Purchased packages and themes require the familiar legacy installation method where code is copied to the `plugins` or `themes` directory.

#### Adding Plugins and Themes with Composer

The project template is configured so Composer can use the [WordPress Packagist](https://wpackagist.org/) (WPackagist) package repository to download packages.

##### Example: Add the Yoast (wordpress-seo) Plugin

Find the Yoast plugin package name on WordPress.org ('wordpress-seo'). Search WPackagist to verify availability of the 'wordpress-seo' package (plugin). Use the WPackagist vendor name ('wpackagist-plugin') and package name ('wordpress-seo') with the Composer 'install' command to add the plugin to the project.

`$ composer require wpackagist-plugin/wordpress-seo`

Composer installs the plugin in the project 'plugins' directory and updates both the `composer.json` and `composer.lock` files to reflect the addition.


#### Adding Purchased Plugins and Themes

Plugins that are purchased cannot be managed with Composer because these proprietary plugins are not available through the public repository (WPackagist). Need to modify .gitignore to include the plugin or theme in the repository
Manually install the plugin or theme in the `.../wp-content/plugins` or `.../wp-content/themes` directory.


##### Example: Add the Divi Theme

Divi is a popular proprietary (purchased) theme used to design WordPress sites. With Composer managing the default themes included with each WordPress release, the template `.gitignore` file specifies that all themes stored in the `/public/wp-content/themes/` folder should be ignored and not stored in the Git repository.

In many instances, a project uses a proprietary theme that doesn't provide Composer support. In that case, the proprietary theme must be manually installed in the `themes` directory and should be included in the Git repository. Here's an example using the popular *Divi* theme.

*Example theme related lines in /.gitignore*

```
# THEMES
# ignore all themes 
/public/wp-content/themes/*
# but don't ignore proprietary themes; include in repo
!/public/wp-content/themes/Divi/
!/public/wp-content/themes/Divi-child/
```

##### Example: Add the Bloom Plugin

Elegant Themes, the maker of Divi, also offers several proprietary plugins. *Bloom* adds support for email harvesting. Since it is a paid plugin that doesn't offer a Composer compatible repository, the `.gitignore` file should be modified to include the plugin once it is manually added to the `plugins` directory.

*Example plugin related lines in /.gitignore*

```
# PLUGINS
# ignore all plugins
/public/wp-content/plugins/*
# but don't ignore proprietary plugins; store in repo
!/public/wp-content/plugins/bloom/
```

##### Push Changes to the Remote Repository

Use Git to commit new and changed files to the local repository and push the changes to the remote repository.


## Updating WordPress core, plugins, and themes

Composer uses two files to manage code dependencies. The `composer update` command updates packages to satisfy the dependencies specified in `composer.json`. The `composer install` command updates packages to the versions specified in `composer.lock`. Use *Update* on staging and *Install* on production. Why? The Composer `composer update` command compares installed versions to version dependencies from the composer.json file. If updates are available that meet the version dependency instructions, the update is downloaded and installed and the new version information is written to composer.lock. All that's needed in production is to have Composer *install* the updated version. Refer to the Composer documentation for more details on these commands.
 
### Composer Supported Updates

Composer supports installing and updating WordPress core, themes, and plugins. The template uses mirrored code bases compatible with Composer. Refer to the following section `Purchased Plugins and Themes` if a plugin or theme is not available through WPackagist.

##### Example: Update plugins on the STAGING server

Run the `composer outdated` command to list pending package updates based upon the settings in `composer.json`.

```
$ composer outdated
wpackagist-plugin/mailgun       1.5.14 1.6.1
wpackagist-plugin/maxbuttons    7.5.2  7.6
wpackagist-plugin/wordpress-seo 8.3    9.0.2
```
There are three packages that need updates: mailgun, maxbuttons, and wordpress-seo. Run the `composer update` command to perform the updates.

```
$ composer update
Loading composer repositories with package information
Updating dependencies (including require-dev)
Package operations: 0 installs, 3 updates, 0 removals
  - Updating wpackagist-plugin/maxbuttons (7.5.2 => 7.6): Downloading (100%)
  - Updating wpackagist-plugin/wordpress-seo (8.3 => 8.4): Loading from cache
  - Updating wpackagist-plugin/mailgun (1.5.14 => 1.6.1): Downloading (100%)
Writing lock file
Generating autoload files
```

Run `git status` and the only changed files are `composer.json` and `composer.lock`. File changes for the three plugins don't appear because the `plugins` directory is listed in the `.gitignore` file.

##### Push Changes to the Remote Repository

Use Git to commit new and changed files to the local repository and push the changes to the remote repository.

### WordPress Core Updates

When Composer updates a package (WordPress core, plugin, theme, ...) the existing package code is replaced (not merged) with the updated package code. Updating to a new WordPress distribution creates a new `wp-content` folder inside the project's `wp` folder. In future versions of this template the active `wp-content` directory under the project's `public` directory will be updated with the updated files from new distribution's `wp-content` folder. Until then, the new `wp-content` folder contents must be copied to the project `wp-content` folder, afterwhich the new `wp-content` folder should be deleted.

## Updating Production

Composer and Git make it easy to update the production server once new code, updates, and testing are completed on the staging server. Git handles updating the code stored in the repository and Composer updates the dependencies specificed in `composer.lock`.

### On the Production Server

To install the newest release code from the remote repository to the production server,  update the project Git database and checkout the codebase corresponding to a release tag, for example r4.1

```
$ git fetch
$ git checkout r4.1
```

Update the Composer managed packages

`$ composer install`

Finally, clear the WordPress cache with a tool such as [wp-cli](https://wp-cli.org/).

`$ wp-cli cache flush`


## Technical Information

Composer manages three key components:
* WordPress core
* plugins
* themes

Eclectic's WordPress template uses a [special Composer installer]( https://github.com/johnpbloch/wordpress-core-installer) that installs WordPress in a subdirectory and moves the locations of `WP_CONTENT_DIR` and `WP_CONTENT_URL` outside of the WordPress core directory. This allows managing WordPress core without disturbing installed plugins, themes, and uploads. Composer is configured to manage plugins available through [WordPress Packagist]( https://wpackagist.org/), a site that mirrors the WordPress.org plugin and theme directories.
