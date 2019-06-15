FROM gitpod/workspace-full

USER root

RUN apt-get update && apt-get -y install apache2 mysql-server php-curl php-gd php-mbstring php-xml php-xmlrpc

RUN echo "include /workspace/wordpress-hello/gitpod_config/apache/apache.conf" > /etc/apache2/apache2.conf
RUN echo ". /workspace/wordpress-hello/gitpod_config/apache/envvars" > /etc/apache2/envvars

RUN echo "!include /workspace/wordpress-hello/gitpod_config/mysql/mysql.cnf" > /etc/mysql/my.cnf

RUN mkdir /var/run/mysqld
RUN chown gitpod:gitpod /var/run/apache2 /var/lock/apache2 /var/run/mysqld

RUN addgroup gitpod www-data

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar
RUN sudo mv wp-cli.phar /usr/local/bin/wp
