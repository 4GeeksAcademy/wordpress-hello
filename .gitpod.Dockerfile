# Gitpod docker image for WordPress | https://github.com/luizbills/gitpod-wordpress
# License: MIT (c) 2019 Luiz Paulo "Bills"
# Version: 0.4
FROM gitpod/workspace-mysql

### General Settings ###
ENV PHP_VERSION="7.3"
ENV APACHE_DOCROOT="public_html"

# - install Apache
# - install PHP
USER root
RUN apt-get update \
    && apt-get -y install apache2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    && chown -R gitpod:gitpod /var/run/apache2 /var/lock/apache2 /var/log/apache2 \
    && echo "include ${HOME}/wordpress-hello/apache/apache.conf" > /etc/apache2/apache2.conf \
    && echo ". ${HOME}/wordpress-hello/conf/envvars" > /etc/apache2/envvars \
    && apt-get -y remove php* \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get -y install libapache2-mod-php \
        php${PHP_VERSION} \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-json \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-soap \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-opcache \
        php-xdebug \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    && cat $HOME/wordpress-hello/gitpod_config/php/php.ini >> /etc/php/${PHP_VERSION}/apache2/php.ini \
    && a2dismod php* \
    && a2dismod mpm_* \
    && a2enmod mpm_prefork \
    && a2enmod php${PHP_VERSION}

# - install WP-CLI
# - install Xdebug
# - install MailHog
USER root
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        -O $HOME/wp-cli.phar \
    && wget -q https://raw.githubusercontent.com/wp-cli/wp-cli/v2.3.0/utils/wp-completion.bash \
        -O $HOME/wp-cli-completion.bash \
    && chmod +x $HOME/wp-cli.phar \
    && mv $HOME/wp-cli.phar /usr/local/bin/wp \
    && chown gitpod:gitpod /usr/local/bin/wp

# - download Adminer from https://www.adminer.org/
USER gitpod
RUN mkdir $HOME/wordpress-hello/adminer/ \
    && wget -q https://github.com/vrana/adminer/releases/download/v4.7.4/adminer-4.7.4-mysql.php \
        -O $HOME/wordpress-hello/adminer/index.php