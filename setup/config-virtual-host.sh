#!/usr/bin/env bash
#
# setup the web server virtual host
#

# full path to the virtual host conf directories
declare -A virtual_host_dirs
virtual_host_dirs[apache]="/etc/apache2/sites-available"
virtual_host_dirs[nginx]="/etc/nginx/sites-available"

# $0 WS_USER
# $1 WS_GROUP
# $2 WS_ROOT
# $4 WS_BASEDIR
# $5 PROJECT_DOMAIN

setup_virtual_host () {

    #---
    # Web server virtual host config directory
    #---
    WS_VIRTUALHOST_DIR=${virtual_host_dirs[$WS_SOFTWARE]}

    case "$WS_SOFTWARE" in
        apache)
            echo "... configure apache virtual host ..."
            # create the web root .htaccess file with the project domain
            sed -e "s/SPACELAUNCH.COM/$PROJECT_DOMAIN/" "${CONFIG_DIR}/apache/public_htaccess" > public/.htaccess
            # create the default .htaccess in the wordpress core directory
            cp "${CONFIG_DIR}/apache/wp_htaccess_default" public/wp/.htaccess
            ;;

        nginx)
            echo "... configure nginx virtual host ..."
            ;;

        *)
            echo "Invalid web server software:[$WS_SOFTWARE]"
            exit 1
            ;;
    esac

    #---
    # save a patched virtual host config
    #---
    CONF_INFILE=$CONFIG_DIR/$WS_SOFTWARE/example.conf
    CONF_OUTFILE=$CONFIG_DIR/$WS_SOFTWARE/$PROJECT_DOMAIN.conf
    sed -e "s|PROJECT_DOMAIN|$PROJECT_DOMAIN|; s|DOCUMENT_ROOT|$WS_BASEDIR/public|" "$CONF_INFILE" >"$CONF_OUTFILE"
    echo "..patched virtual host config written to $CONF_OUTFILE"

    #---
    # interactive copy of virtual host config file to web server config directory
    # ---
    echo "Grant permissions to save virtual host file $CONF_OUTFILE to configuration directory ${WS_VIRTUALHOST_DIR}?"
    sudo cp -i $CONF_OUTFILE $WS_VIRTUALHOST_DIR/$PROJECT_DOMAIN.conf
    echo "..patched virtual host config $CONF_OUTFILE written to $WS_VIRTUALHOST_DIR/$PROJECT_DOMAIN.conf"

}

# ----- end of config-virtual-host.sh -----
