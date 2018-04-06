#!/bin/bash -e

red='\e[31m'
cyan='\e[33m'
blue='\e[34m'
bgRed='\e[41m'
bgBlue='\e[44m'
bgCyan='\e[46m'

fullpath=${PWD}
baseSiteDirectory=$(echo $fullpath | sed 's/.*workspace//g')

echo "================================================================="
echo -e "$blue 4Geeks Academy\e[0m WordPress Installer!!"
echo "================================================================="
print_error () { 
    echo -e "$bgRed Error!\e[0m $red $1\e[0m" 
}
print_info () { 
    echo -e "$cyan $1\e[0m" 
}
print_hint () { 
    echo -e "$bgBlue Hint:\e[0m $1" 
}
print_question () { 
    echo -e "$bgCyan input>\e[0m $cyan $1 \e[0m" 
}

git --version > /dev/null
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE -eq 0 ]; 
    then echo "" 
    else print_error "No wordpress installation found" 
fi

if [ -d "./wp-content" ]; 
    then
        echo "Wordpress installation was found, proceeding..."
    else 
        print_error "No wordpress installation found"
        print_hint "Make sure you have a wp-content folder in the current directory:"
        ls -a
        exit
fi

echo "" 
if [ -d "./vendor" ]; 
    then
        echo "Composer was found, proceeding with the installation..."
    else 
        print_error "You need to install the composer packages first"
        print_hint "Run: $ composer install\e[0m"
        exit
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

echo "Running MySQL"
mysql-ctl start

phpmyadmin-ctl install

# add a simple yes/no confirmation before we proceed
print_question "Do you want to run the whole installation? (y/n)"
read -e run
# if the user didn't say no, then go ahead an install
if [ "$run" != y ] ; then
echo "Exiting the installation"
exit
else


if [ -d "./wp-includes" ]; then
    print_error "WordPress is already installed"
    exit
fi

# accept the name of our website
print_question "What is going to be your site name or title? "
read -e sitename
while [[ $sitename == '' ]] # While string is different or empty...
do
    print_error "Please enter a valid string" # Ask the user to enter a valid string
    read -e sitename
done 

# accept the name of our website
print_question "Choose a password for your WordPress admin:"
read -s sitepassword
while [[ $sitepassword == '' ]] # While string is different or empty...
do
    print_error "Please enter a valid password" # Ask the user to enter a valid string
    read -s sitepassword
done 


# download the WordPress core files
wp core download

# create the wp-config file with our standard setup
wp core config --dbname="c9" --dbuser=$C9_USER --dbpass= --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'DISALLOW_FILE_EDIT', true );
PHP

# parse the current directory name
wp core install --url="https://$C9_HOSTNAME/$baseSiteDirectory" --title="$sitename" --admin_user="$C9_USER" --admin_password="$sitepassword" --admin_email=$C9_EMAIL

# create database, and install WordPress

# discourage search engines
wp option update blog_public 0

# delete sample page, and create homepage
wp post delete $(wp post list --post_type=page --posts_per_page=1 --post_status=publish --pagename="sample-page" --field=ID --format=ids)
wp post create --post_type=page --post_title=Home --post_status=publish --post_author=$(wp user get $C9_USER --field=ID --format=ids)

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

phpmyadminPath = "phpmyadmin"
echo "================================================================="
echo "Installation is complete. Your WordPress username/password is listed below."
echo ""
echo "Username: $C9_USER (for wordpress and your database)" 
echo "Password: (whatever you specified earlier)"
echo ""
echo -e "To access your database: $blue\e[4mhttps://$C9_HOSTNAME/$baseSiteDirectory$phpmyadminPath\e[0m"
echo -e "To access your site: $blue\e[4mhttps://$C9_HOSTNAME/$baseSiteDirectory\e[0m"
echo ""
echo "================================================================="

fi
