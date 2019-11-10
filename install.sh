#!/bin/bash

red='\e[31m'
cyan='\e[33m'
blue='\e[34m'
bgRed='\e[41m'
bgBlue='\e[44m'
bgCyan='\e[46m'

fullpath=${PWD}
baseSiteDirectory=$(echo $fullpath | sed 's/.*workspace//g')

echo "================================================================="
echo "$blue \e[0m WordPress Installer!!"
echo "================================================================="
print_error () {
    echo "$bgRed Error!\e[0m $red $1\e[0m"
}
print_info () {
    echo "$bgBlue $1\e[0m"
}
print_hint () {
    echo "$bgBlue Hint:\e[0m $1"
}
print_question () {
    echo "$bgCyan input>\e[0m $cyan $1 \e[0m"
}

if [ -f ./.env ]; then
        print_info "Loading (.env) environment file..."
        . ./.env
    else
        print_error "No .env file was found"
        exit 1
fi

git --version > /dev/null
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE -eq 0 ];
    then echo ""
    else
        print_error "Git is required, but not installed"
        exit 1
fi

composer --version > /dev/null
COMPOSER_IS_AVAILABLE=$?
if [ $COMPOSER_IS_AVAILABLE -eq 0 ];
    then echo ""
    else
        print_error "Composer is required, but not installed"
        exit 1
fi

if [ -d "./wp-content" ];
    then
        print_info "Wordpress installation was found, proceeding..."
    else
        print_error "No wordpress installation found"
        print_hint "Make sure you have a wp-content folder in the current directory:"
        ls -a
        exit 1
fi

wp --info > /dev/null
WP_IS_AVAILABLE=$?
if [ $WP_IS_AVAILABLE -eq 0 ];
    then echo ""
    else
        print_info "Installing wordpress cli..."
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        sudo mv wp-cli.phar /usr/local/bin/wp
fi

if [ -d "./wp-includes" ]; then
        if [ "$1" == "--force" ]; then
                print_info "WordPress is already installed, proceeding with the rest of the installation..."
    	    else
                print_info "WordPress is already installed"
                exit 1
        fi
    else
        # download the WordPress core files
        rm $fullpath/index.php
        wp core download
fi

# create the wp-config file with our standard setup
wp core config --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'DISALLOW_FILE_EDIT', true );
PHP

echo ""
if [ -f "./wp-config.php" ];
    then
        print_info "wp-config.php successfully created..."
    else
        print_error "The wp-config.php file could not be created, make sure your database credentials are ok."
        exit 1
fi

# parse the current directory name
wp core install --url="$SITE_URL" --title="$SITE_NAME" --admin_user="$SITE_USER" --admin_password="$SITE_PASS" --admin_email="$SITE_EMAIL"

echo ""
if [ -d "./vendor" ];
    then
        print_info "/vendor folder found, udating packages..."
        composer update
    else
        print_info "NO /vendor folder found, installing packages from scratch..."
        composer install
fi

# discourage search engines
wp option update blog_public 0

# delete sample page, and create homepage
wp post delete $(wp post list --post_type=page --posts_per_page=1 --post_status=publish --pagename="sample-page" --field=ID --format=ids)
wp post create --post_type=page --post_title=Home --post_status=publish --post_author=$(wp user get $SITE_USER --field=ID --format=ids)

# set homepage as front page
wp option update show_on_front 'page'

# set homepage to be the new page
wp option update page_on_front $(wp post list --post_type=page --post_status=publish --posts_per_page=1 --pagename=home --field=ID --format=ids)

# set pretty urls
wp rewrite structure '/%postname%/' --hard
wp rewrite flush --hard

# delete akismet and hello dolly
wp plugin delete akismet
wp plugin delete hello

wp theme activate rigo
wp plugin activate advanced-custom-fields

echo "================================================================="
print_info "Installation is complete."

echo "You can go ahead and chech your website at $SITE_URL"
echo ""
echo "Login to your wordpress with the following credentials:"
echo "User: $SITE_USER"
echo "Password: $SITE_PASS"
echo "================================================================="

exit 0
