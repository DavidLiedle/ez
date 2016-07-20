#!/usr/bin/env bash
################################################################################
# eZ Platform Debian 8.5 Install Script
#
# WORK IN PROGRESS! THIS DOES NOT FULLY INSTALL eZ Platform YET!
#
# This script is only intended to be used on a clean system. If you're trying to
# install on an existing system, you may just want to read the commands below to
# see which ones you need to run to get your system ready.
#
# Known Issues:
# - Running as root pretty much negates the whole -qq quiet flag for apt-get :(
#
# TEST LOG:
# 20160627 DigitalOcean Debian 8.5x64 Droplet, 512 MB RAM / 20GB Disk | OK
#          ssh root@ip means running this script as root by default...
#

export DEBIAN_FRONTEND=noninteractive

export EZ_INSTALL_DIR=/var/www/
export EZ_INSTALL_NAME=ezplatform

echo "Welcome to the eZ Platform Debian 8.5 installer!"
echo -n "Preparing the system for installation..."

################################################################## Ready System:
# System updates:
apt-get -qq -y update
echo -n "."
apt-get -qq -y upgrade
echo -n "."
apt-get -qq -y dist-upgrade
echo "DONE!"
echo

# Install mosh:
echo -n "Installing mosh for superior SSH connectivity..."
apt-get -qq -y install mosh
echo "DONE!"
echo

############################ VERY personal preferences for my DEV environment...
# Install zsh:
echo -n "Installing zsh for CLI awesomeness..."
apt-get -qq -y install zsh
echo "DONE!"
echo

# Install htop:
echo -n "Installing htop for memory/CPU monitoring..."
apt-get -qq -y install htop
echo "DONE! (Simply use 'free' if you don't need the whole ncurses UI...)"
echo

# Install a real text editor:
echo -n "Installing emacs for text editing (vim is already available)..."
apt-get -qq -y install emacs24-nox
echo "DONE!"
echo

######################################################################## YGNI...
# Install git:
echo -n "Installing git..."
apt-get -qq -y install git
echo "DONE!"
echo

# Set up swap:
echo -n "Setting up swap on this system..."
fallocate -l 4G /swapfile
echo -n "."
chmod 600 /swapfile
echo -n "."
mkswap /swapfile
echo -n "."
swapon /swapfile
echo -n "."
sysctl vm.swappiness=10
echo -n "."
sysctl vm.vfs_cache_pressure=50
echo "DONE!"
echo

########################################################################## LAMP:
# Apache2:
echo -n "Installing Apache2..."
apt-get -qq -y install apache2
echo -n "."
apt-get -qq -y install libapache2-mod-php5
echo -n "."
a2enmod rewrite
echo "DONE!"
echo

# MySQL:
echo -n "Installing MySQL..."
apt-get -qq -y install mysql-server mysql-client
echo "DONE!"
echo

# PHP modules:
echo -n "Installing PHP modules..."
apt-get -qq -y install php5-cli \
                       php5-fpm  \
                       php5-json  \
                       php5-xsl    \
                       php5-intl    \
                       php5-mcrypt   \
                       php5-mysqlnd   \
                       php5-curl       \
                       php5-gd          \
                       php5-twig         \
                       php5-memcached
echo "DONE!"
echo

######################################################################## Extras:

# Solr:
echo -n "Installing OpenJDK 7..."
apt-get -qq -y install openjdk-7-jdk openjdk-7-jre
echo -n "installing Solr..."
apt-get -qq -y install php5-solr solr-tomcat
echo "DONE!"
echo

# Varnish:
echo -n "Installing Varnish..."
apt-get -qq -y install varnish
echo "DONE!"
echo

########################################################### Symfony Environment:
# Composer:
echo -n "Installing Composer..."
php -r "readfile('https://getcomposer.org/installer');" | php
echo -n "moving composer to global /usr/local/bin/composer ..."
mv composer.phar /usr/local/bin/composer # Installs composer globally
echo "DONE!"
echo

################################################################### eZ Platform:
echo -n "Installing eZ Platform from GitHub to /var/www/ezplatform ..."
cd /var/www
git clone https://github.com/ezsystems/ezplatform.git
echo "DONE!"
echo

# Composer Install of Dev Environment:
# (Use `php -d memory_limit=-1 `which composer` install --no-dev` for prod)
echo -n "Running Composer's install for a Developer environment..."
cd /var/www/ezplatform
php -d memory_limit=-1 /usr/local/bin/composer install
echo "DONE!"
echo

# MySQL db creation:
mysql -u root -e "create database ezplatform";

# Run eZ Platform's installation for a clean production environment:
php -d memory_limit=-1 app/console ezplatform:install --env prod clean

# A good test of whether everything is configured properly
# https://doc.ez.no/display/DEVELOPER/Devops
#php app/console --env=prod cache:clear

chown -R www-data:www-data /var/www/ezplatform

# Copy the template vhost file for apache into the proper location:
cp /var/www/ezplatform/doc/apache2/vhost.template /etc/apache2/sites-available/ezplatform.conf

# TODO:
# - MAGIC OCCURS substituting %IP_ADDRESS% and several other lines (TBD), perhaps with sed?


a2ensite ezplatform
a2dissite 000-default.conf # disable the default vhost

# Restart apache (apachectl restart also works)
echo -n "Restarting Apache 2..."
service apache2 restart
echo "DONE!"
echo

echo "System is now installed. You may disconnect your SSH session and re-connect via mosh."
echo "BE SURE TO SET A ROOT PASSWORD FOR MYSQL! It is presently blank. Update in config as well."
echo

exit 0
