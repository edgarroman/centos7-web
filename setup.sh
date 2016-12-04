#!/bin/bash
set -e
source /image_build/buildconfig

header "Setting up script directory"

# ensure all newly created directories and files are group accessible
run umask 002

# For binaries and scripts
SETUP_DIR_BIN=/usr/local/bin/
run mkdir -p $SETUP_DIR_BIN

# For daemons and network services
SETUP_DIR_SBIN=/usr/local/sbin/
run mkdir -p $SETUP_DIR_SBIN

header "Installing tini"
TINI_VERSION=v0.13.0
run wget https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini -O $SETUP_DIR_SBIN/tini
run wget https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini.asc -O $SETUP_DIR_SBINtini.asc
#run gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
# && gpg --verify /tini.asc
run chmod g+x $SETUP_DIR_SBIN/tini

##########################################################################
# Install NGINX
run /image_build/nginx/setup_nginx.sh

##########################################################################
# Install uwsgi
run yum -y install uwsgi

##########################################################################
# Install our entrypoint script to handle when started as a random user
run cp -r /image_build/entrypoint.sh $SETUP_DIR_BIN/entrypoint.sh
run chmod g+x $SETUP_DIR_BIN/entrypoint.sh;

##########################################################################
# For all the files we created we need to assign them to group zero and allow users of group zero
# to be able to read and write
chgroup_dir_to_rw_zero $SETUP_DIR_SBIN
chgroup_dir_to_rw_zero $SETUP_DIR_BIN
