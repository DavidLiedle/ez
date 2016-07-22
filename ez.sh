#!/usr/bin/env bash
################################################################################
# eZ CLI Management
#

# TODO: Kind of thinking about an interactive status / tooling script here

#
# Right now, personally, I'm using this raw file to pull into DigitalOcean
# to test fresh droplets with Debian 8.5:
#
# https://raw.githubusercontent.com/DavidLiedle/ez/master/ezplatform-install-debian-8-5.sh
#
# This is testing to update eZ Platform's requirements:
#   https://doc.ez.no/pages/viewpage.action?pageId=31429536
# ..and Unix-Based System Installation Instructions:
#   https://doc.ez.no/display/DEVELOPER/Installation+Guide+for+Unix-Based+Systems
#

echo "Nothing here! Visit https://github.com/DavidLiedle/ez/blob/master/ezplatform-install-debian-8-5.sh"

# Choose the type of install:
# - Debian 8.5
# - Ubuntu 16.04
# Choose the type of stack:
# - Apache2, MySQL, PHP5.6
# - Nginx, MariaDB, PHP7
#

# Utility functions:
# - Sync latest ezsystems/ezplatform with my fork:
# git fetch ezsystems
# git checkout master
# git rebase ezsystems/master
# git push origin/master
#
#
