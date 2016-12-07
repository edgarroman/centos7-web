#!/bin/bash
set -e
source /image_build/buildconfig

header "Setting up uWSGI"

USER_NAME=default
USER_HOME=/opt/app-root/src
UWSGI_USER_CONF_DIR=$USER_HOME/etc/

#run yum -y install uwsgi
run pip install uwsgi

# Place a dummy wsgi application file in the user directory
run cp -r /image_build/uwsgi/hello.wsgi $USER_HOME/hello.wsgi

# Alright, now setup default uwsgi webapp
run ln -s $USER_HOME/hello.wsgi $USER_HOME/main.wsgi

# make log directory
run mkdir -p /var/log/uwsgi
chgroup_dir_to_rw_zero "/var/log/uwsgi"

# Install the startup file
run mkdir /etc/service/uwsgi
run cp -r /image_build/uwsgi/uwsgi.sh $USER_HOME/uwsgi.sh
run chmod +x $USER_HOME/uwsgi.sh
