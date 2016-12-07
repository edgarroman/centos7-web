# This is the little script that just starts both 
# NGINX daemon and uWSGI process
# We rely on the entrypoint tini process to do the 
# proper zombie reaping
nginx
USER_HOME=/opt/app-root/src
$USER_HOME/uwsgi.sh