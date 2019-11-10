# Gitpod docker image for WordPress | https://github.com/luizbills/gitpod-wordpress
# License: MIT (c) 2019 Luiz Paulo "Bills"
# Version: 0.4
FROM gitpod/workspace-mysql

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
