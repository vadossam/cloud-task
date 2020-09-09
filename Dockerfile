FROM ubuntu:18.04
ENV LS_FD='/usr/local/lsws'

ARG LSWS_VERSION
ARG PHP_VERSION

RUN apt-get update && apt-get install -y \
    cron \
    curl \
    ed \
    tzdata \
    unzip \
    wget

COPY template/lsws-install.sh template/wordpress.sh template/entrypoint.sh .env /
RUN chmod +x /lsws-install.sh && bash /lsws-install.sh $LSWS_VERSION

RUN apt-get install -y \
    mysql-client \
    $PHP_VERSION \
    $PHP_VERSION-common \
    $PHP_VERSION-mysql \
    $PHP_VERSION-opcache \
    $PHP_VERSION-curl \
    $PHP_VERSION-json \
    $PHP_VERSION-imagick \
    $PHP_VERSION-redis \
    $PHP_VERSION-memcached \
    $PHP_VERSION-intl \
  && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp && \
	ln -s /usr/local/lsws/$PHP_VERSION/bin/php /usr/bin/php

COPY template/docker.xml $LS_FD/conf/templates/docker.xml
COPY template/setup_docker.sh $LS_FD/bin/setup_docker.sh
COPY template/httpd_config.conf $LS_FD/conf/httpd_config.conf
COPY template/htpasswd $LS_FD/admin/conf/htpasswd

RUN $LS_FD/bin/setup_docker.sh $PHP_VERSION && rm $LS_FD/bin/setup_docker.sh
RUN chown 999:999 $LS_FD/conf -R
RUN cp -RP $LS_FD/conf/ $LS_FD/.conf/
RUN cp -RP $LS_FD/admin/conf $LS_FD/admin/.conf/
RUN ln -sf $LS_FD/$PHP_VERSION/bin/lsphp $LS_FD/fcgi-bin/lsphp7

RUN chmod +x /wordpress.sh && bash wordpress.sh && rm /.env /wordpress.sh
COPY template/const.default.ini /var/www/vhosts/localhost/html/wp-content/plugins/litespeed-cache/data/const.default.ini

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /var/www/vhosts/
