#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Prints a formatted message in the screen
function print {
	yellow='\033[0;33m'
	purple='\033[0;35m'
	red='\033[0;31m'
	green='\033[0;32m'
	nocolor='\033[0m'
	case $1 in
	    "error")
			echo -e "${red}### ERROR: $2${nocolor}"
	    ;;
	    "info")
			echo -e "${yellow}$2${nocolor}"
	    ;;
	    "help")
			echo -e "${green}$2${nocolor}"
	    ;;
	    "purple")
			echo -e "${purple}$2${nocolor}"
	    ;;
	esac
}

# There must be a configuration file
if [ -f 'ezplatform.conf' ]; then
	. ezplatform.conf
else
	print error "No ezplatform.conf found. Using the default ezplatform.conf.ori file."
	. ezplatform.conf.ori
fi

# Updates the system
function update_system {
	if [ $opt_update_system != 'yes' ]; then
		print purple "Won't update the system."
		return 0
	fi
	print info "Updating system..."
	apt-get -qq -y update
	apt-get -qq -y upgrade
	apt-get -qq -y dist-upgrade
	print info "Done updating system."
}

# Install advanced editors like VIM & Emacs
function install_editors {
	print info "Installing advanced editors..."
	if [ $opt_install_emacs != 'yes' ]; then
		print purple "Won't install Emacs."
	else
		print info "Installing Emacs."
		apt-get -qq -y install emacs24-nox
	fi

	if [ $opt_install_vim != 'yes' ]; then
		print purple "Won't install Vim."
	else
		print info "Installing vim."
		apt-get -qq -y install vim
	fi
	print info "Done installing advanced editors."
}

# Install non editors packages like GIT
function install_others {
	print info "Installing other software..."

	if [ $opt_install_emacs != 'yes' ]; then
		print purple "Won't install mosh for superior SSH connectivity"
	else
		print info "Installing mosh for superior SSH connectivity..."
		apt-get -qq -y install emacs24-nox
	fi

	if [ $opt_install_composer != 'yes' ]; then
		print purple "Won't install composer globally for easier access."
	else
		print info "Installing composer globally for easier access..."
		php -r "readfile('https://getcomposer.org/installer');" | php
		mv composer.phar /usr/local/bin/composer
	fi

	print info "Installing Git..."
	apt-get -qq -y install git
	print info "Done installing other software."
}

# Install MySQL or MariaDB
function install_database_servers {
	print info "Installing database servers..."
	if [ $opt_install_mariadb != 'yes' ]; then
		print purple "Won't install MariaDB."
	else
		if [ ! -z "`dpkg --get-selections mysql-server`" ]; then
			print purple "MySQL Server is already installed. Won't install MariaDB."
		else
			print info "Installing MariaDB..."
			apt-get -qq -y install mariadb-server mariadb-client
		fi
	fi

	if [ $opt_install_mysql != 'yes' ]; then
		print purple "Won't install MySQL."
	else
		if [ ! -z "`dpkg --get-selections mariadb-server`" ]; then
				print purple "MariaDB Server is already installed. Won't install MySQL."
		else
			print info "Installing MySQL..."
			apt-get -qq -y install mysql-server mysql-client
		fi
	fi
	print info "Done installing database servers."
}

# Sets a swap file in the system
function set_swap {
	print info "Setting up swap on this system..."
	if [ $opt_set_swap != 'yes' ]; then
		print purple "Won't set up swap on this system."
		return 0
	fi

	re='^[0-9]+$'
	if ! [[ $opt_swap_size =~ $re ]]; then
		print error "The swap size is invalid. It must be numeric only. Won't set up swap on this system."
		return 0
	fi

	fallocate -l ${1}G /swapfile
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	sysctl vm.swappiness=10
	sysctl vm.vfs_cache_pressure=50

	print info "Done setting up swap on this system."
}

# Install Web server related packages
function install_web_packages {
	print info "Installing Apache..."
	apt-get -qq -y install apache2 libapache2-mod-php5
	a2enmod rewrite

	#@TODO: Add an automatic config for vhosts

	print info "Installing PHP packages..."
	apt-get -qq -y install php5-cli php5-json php5-xsl php5-intl php5-mcrypt php5-curl php5-gd

	#@TODO: Add php5-twig install

	if [ $opt_install_memcached != 'yes' ]; then
		print purple "Won't set up PHP Memcached on this system."
	else
		print info "Installing PHP Memcache..."
		apt-get -qq -y install php5-memcached
	fi

	if [ $opt_install_varnish != 'yes' ]; then
		print purple "Won't set up Varnish on this system."
	else
		print info "Installing Varnish..."
		apt-get -qq -y install varnish
	fi

	#TODO: Add automatic config for Varnish

	service apache2 restart

	print info "Done installing Apache & PHP packages."
}

function install_ezplatform {
	print info "Installing eZ Platform from GitHub to /var/www/ezplatform ..."
	if [ ! -d $opt_www_dir ]; then
		print error "The $opt_www_dir does not exist. Aborting script..."
		exit 1
	fi

	if [ -d $opt_www_dir/$opt_ezp_folder ]; then
		print purple "Removing old eZ Platform folder..."
		rm -Rf $opt_www_dir/$opt_ezp_folder
	fi

	cd $opt_www_dir
	git clone https://github.com/ezsystems/ezplatform.git $opt_ezp_folder
	chown -R $opt_apache_user:$opt_apache_group $opt_www_dir/$opt_ezp_folder
}

print info "Installing eZ Platform in a Debian based environment..."
update_system
install_editors
install_others
set_swap
install_database_servers
install_web_packages
install_ezplatform
print info "Done installing eZ Platform in a Debian based environment..."
