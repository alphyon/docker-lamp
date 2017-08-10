FROM ubuntu:latest
MAINTAINER José A. Chavarría alphyon21@gmail.com
LABEL version=“2.0” description="Image with webdevelopment tools"
ENV DEBIAN_FRONTEND noninteractive 
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www/html/
RUN apt-get update -y
RUN echo mysql-server mysql-server/root_password select devpruebas | debconf-set-selections
RUN echo mysql-server mysql-server/root_password_again select devpruebas | debconf-set-selections
RUN apt-get install -y apt-utils
RUN apt-get install -y mysql-server mysql-client
RUN apt-get install -y software-properties-common
RUN export LANG=C.UTF-8 && add-apt-repository -y ppa:ondrej/php 
RUN apt-get update
RUN apt-get install -y apache2 libapache2-mod-php7.1
RUN apt-get install -y php7.1-fpm php7.1 php7.1-mysql php7.1-sqlite3 php7.1-pgsql php7.1-curl php7.1-mcrypt php7.1-intl php7.1-bz2 php7.1-imap php7.1-gd php7.1-json php7.1-mbstring php7.1-ldap php7.1-zip php7.1-xml php7.1-soap
RUN apt-get install -y wget curl python
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"
RUN npm install -g gulp gulp-cli
RUN npm install -g webpack

COPY ./config/php.ini   /etc/php/7.1/apache2/
ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
ENV TERM dumb
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html
RUN apt-get --purge autoremove
VOLUME ["/var/www/html"]
COPY ./config/docker-entrypoint.sh /usr/local/bin/
COPY ./config/mysqld.cnf /etc/mysql/mysql.conf.d/
RUN chmod +x usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["usr/local/bin/docker-entrypoint.sh"]
EXPOSE 80 
EXPOSE 3306
CMD ["bash"]