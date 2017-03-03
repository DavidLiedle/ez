# install eZ Platform / eZ Platform EE as a remote dev environment
echo "Not yet implemented"
exit 1

# Debian:
apt-get update
apt-get upgrade
apt-get -y dist-upgrade
apt-get -y install zsh
apt-get -y install htop
apt-get -y install emacs24-nox
apt-get -y install git
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
sysctl vm.swappiness=10
sysctl vm.vfs_cache_pressure=50
apt-get -y install apache2
apt-get -y install libapache2-mod-php5
apt-get -y install php5-cli # ...
apt-get -y install varnish

mv composer.phar /usr/local/bin/composer
cd /var/www
git clone https://github.com/ezsystems/hibu-ezstudio.git
apt-get install -y vsftp
apt-get install -y vsftpd
clear
pwd
la
ls -la
which zsh
passwd
chsh

#ohmyz.sh
upgrade_oh_my_zsh # (Use my script)
apt-get -y install ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow www
ufw allow sftp
ufw allow 60000:61000/udp
ufw enable
useradd david # me
# interactive mode for that
chsh david # change to zsh
# use git to get a copy of the desired product

apt-get install -y mysql-server mysql-client
# export PLATFORM_RELATIONSHIPS=LONGKEYHERE
php -d memory_limit=-1 /usr/local/bin/composer install # in the correct directory
chown -R www-data:www-data /var/www
apt-get install php5-redis
cp /var/www/hibu-ezstudio/wwwroot/doc/apache2/vhost.template /etc/apache2/sites-available/ezstudio.conf
# editing of the vhost template was done manually
a2ensite ezstudio
service apache2 reload
service apache2 restart
php -d memory_limit=-1 app/console ezplatform:install --env prod clean
a2enmod rewrite

# Options:
# - Use Open Source or EE editions
# - Use Apache2 or Nginx
# - Install SolR?
#   - ufw enable 8983 ?
# - memcached or redis?
#
apt-get install redis-server
service redis-server start

zcat ./db.sql.gz|mysql -u root -p ezstudio
apt-get -y install screen
# wget https://github.com/vrana/adminer/releases/download/v4.2.5/adminer-4.2.5.php
# put in the right directory
