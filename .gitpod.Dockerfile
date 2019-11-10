FROM mattrayner/lamp:latest-1804

#PORT 80
#USER root

#RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

#RUN chmod +x wp-cli.phar
#RUN sudo mv wp-cli.phar /usr/local/bin/wp

CMD ["/run.sh"]
