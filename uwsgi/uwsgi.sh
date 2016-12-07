#!/bin/sh
# `/sbin/setuser webuser` runs the given command as the user `webuser`.
# If you omit that part, the command will be run as root.
#
# TODO look at sane options: https://github.com/GrahamDumpleton/warpdrive/blob/master/warpdrive/etc/start-uwsgi
#
USER_NAME=default
USER_HOME=/opt/app-root/src

exec /opt/rh/rh-python35/root/usr/bin/uwsgi \
    --socket /tmp/uwsgi.sock \
    --chmod-socket=666 \
    --master \
    --wsgi-file /opt/app-root/src/main.wsgi \
    >>/var/log/uwsgi/uwsgi.log 2>&1
