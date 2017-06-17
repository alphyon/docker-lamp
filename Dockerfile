FROM ubuntu:latest
MAINTAINER José A. Chavarría alphyon21@gmail.com
LABEL version="1.0" description="Image with webdevelopment tools"
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
RUN apt-get install -y apache2 libapache2-mod-php7.0
RUN apt-get install -y php7.0-fpm php7.0 php7.0-mysql php7.0-sqlite3 php7.0-pgsql php7.0-curl php7.0-mcrypt php7.0-intl php7.0-bz2 php7.0-imap php7.0-gd php7.0-json php7.0-mbstring php7.0-ldap php7.0-zip php7.0-xml php7.0-soap
RUN apt-get install -y wget curl python
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"
RUN npm install -g gulp gulp-cli
RUN npm install -g webpack
RUN apt-get update
RUN apt-get install -y libapt-pkg-perl libauthen-pam-perl libio-pty-perl libnet-ssleay-perl
RUN apt-get update
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes
RUN apt-get purge -y apt-show-versions
RUN rm /var/lib/apt/lists/*lz4
RUN apt-get -o Acquire::GzipIndexes=false update
RUN apt-get install -y apt-show-versions
RUN wget http://prdownloads.sourceforge.net/webadmin/webmin_1.791_all.deb

RUN dpkg -i webmin_1.791_all.deb
RUN /usr/share/webmin/changepass.pl /etc/webmin root test123
RUN rm webmin_1.791_all.deb
COPY ./config/php.ini   /etc/php/7.0/apache2/
ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
ENV TERM dumb
RUN a2enmod rewrite
RUN apt-get install -y phpmyadmin
RUN ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
RUN chown -R www-data:www-data /var/www/html
RUN a2enconf phpmyadmin.conf
RUN apt-get --purge autoremove
VOLUME ["/var/www/html"]
VOLUME ["/var/lib/mysql"]
COPY ./config/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["usr/local/bin/docker-entrypoint.sh"]
EXPOSE 80 
EXPOSE 3306
EXPOSE 10000
CMD ["bash"]