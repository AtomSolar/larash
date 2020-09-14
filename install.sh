#!/bin/bash

#Instructions to use this script
#
#chmod +x SCRIPTNAME.sh
#
#sudo ./SCRIPTNAME.sh


########################################################################
# Installing and Configuring Apache & Nginx with PHP 7.4               #
# Apache will run on port 8080 and will be behind Nginx                #
# Nginx will serve as a reverse proxy for Apache Sites                 #
# Nginx will act as the primary web and caching server                 #
########################################################################


echo "###################################################################################"
echo "LAMP Installation Starting | Installing the following:"
echo "Apache (apache2), PHP (php7.4), MySQL (mysql-server)"
echo "###################################################################################"


#PHP7 PPA
# sudo apt-get install python-software-properties
# sudo add-apt-repository ppa:ondrej/php


# Update Packages
sudo apt update && sudo apt upgrade -y


# Install Apache2 Server
sudo apt install apache2 -y

# Modify Apache Ports to Listen on Port 80 (http) and 8443 (https)
# sudo sed -i 's/80/8080/' /etc/apache2/ports.conf
# sudo sed -i 's/443/8443/' /etc/apache2/ports.conf

# Restart Apache service to listen on the new ports
sudo systemctl restart apache2

# Now, let's install Nginx as the primary web server to listen on Ports 80 & 443 for Non-SSL and SSL respectively
# sudo apt install nginx -y

# Add the PHP Repository for Multi-PHP Version Installation
sudo add-apt-repository ppa:ondrej/php -y


# PHP Version 7.4
sudo apt install -y \
    libapache2-mod-php7.4 \
    php7.4 \
    php7.4-bcmath \
    php7.4-bz2 \
    php7.4-cli \
    php7.4-common \
    php7.4-curl \
    php7.4-enchant \
    php7.4-fpm \
    php7.4-gd \
    php7.4-intl \
    php7.4-json \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-opcache \
    php7.4-readline \
    php7.4-soap \
    php7.4-sqlite3 \
    php7.4-tidy \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-xsl \
    php7.4-zip

# Miscellanous PHP Packages
sudo apt install -y \
    php-pear \
    php-xdebug


# Install Development Packages
sudo apt install php7.4-dev

# Restart all PHP FPM services
sudo systemctl restart php7.4-fpm

# Enable PHP 7.4-FPM Module
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php7.4-fpm


# To Switch PHP FPM Version for Apache the following commands should be used
# sudo a2disconf php<ver>-fpm && sudo a2enconf php<ver>-fpm
sudo systemctl reload apache2

# To enable Nginx Reverse Proxy for Apache, add the following to the Nginx specific site configuration
# location ~ \.php$ {
#         proxy_set_header X-Real-IP $remote_addr;
#         proxy_set_header X-Forwarded-For $remote_addr;
#         proxy_set_header Host $host;
#         proxy_pass http://127.0.0.1:8080;
# }

# To switch CLI PHP version to another than the default use the following syntax
# sudo update-alternatives --set php /usr/bin/php<version>

# For Example (Replace 7.4 with your PHP version)
# sudo update-alternatives --set php /usr/bin/php7.4
# sudo update-alternatives --set phar /usr/bin/phar7.4
# sudo update-alternatives --set phar.phar /usr/bin/phar.phar7.4
# sudo update-alternatives --set php-config /usr/bin/php-config7.4
# sudo update-alternatives --set phpize /usr/bin/phpize7.4

########################################################################
# Now configure your Apache and Nginx Virtual Hosts / Sites            #
# Enjoy!                                                               #
#########





#The following commands set the MySQL root password to TestPassword! when you install the mysql-server package.

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password TestPassword!'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password TestPassword!'
sudo apt install mysql-server -y

#Restart all the installed services to verify that everything is installed properly

echo -e "\n"

service apache2 restart && service mysql restart > /dev/null

echo -e "\n"

php -v

if [ $? -ne 0 ]; then
  echo "Please Check the Install Services, There is some $(tput bold)$(tput setaf 1)Problem$(tput sgr0)"
else
  echo "Installed Services run $(tput bold)$(tput setaf 2)Sucessfully$(tput sgr0)"
fi

echo -e "\n"
