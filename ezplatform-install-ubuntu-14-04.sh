#!/usr/bin/env bash
################################################################################
# eZ Platform Ubuntu 14.04 Install Script
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
# 20160627 DigitalOcean Ubuntu 14.04.4x64 Droplet, 512 MB RAM / 20GB Disk | OK
#          ssh root@ip means running this script as root by default...
#

echo "Welcome to the eZ Platform Ubuntu 14.04 installer!"
echo -n "Preparing the system for installation..."

################################################################## Ready System:
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

# Install git:
echo -n "Installing git..."
apt-get -qq -y install git
echo "DONE!"
echo

# Install a real text editor:
echo -n "Installing emacs for text editing (vim is already available)..."
apt-get -qq -y install emacs24-nox
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
                       php5-curl      \
                       php5-gd         \
                       php5-twig        \ # Test on non-DO images?
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

# TODO:
# - cp example config file for apache...
# - a2ensite ezplatform
#   - Does this: cd /etc/apache2/sites-enabled; ln -s /etc/apache2/sites-available/ezplatform.conf ezplatform.conf
# - git config --global push.default simple

# Restart apache (apachectl restart also works)
echo -n "Restarting Apache 2..."
service apache2 restart
echo "DONE!"
echo

echo "System is now installed. You may disconnect your SSH session and re-connect via mosh."
echo

exit 0
