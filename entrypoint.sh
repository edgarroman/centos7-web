#!/bin/sh
# Override user ID lookup to cope with being randomly assigned IDs using
# the -u option to 'docker run'.

USER_ID=$(id -u)
GROUP_ID=$(id -g)

SETUP_DIR_SBIN=/usr/local/sbin
SETUP_DIR_BIN=/usr/local/bin


if [ x"$USER_ID" != x"0" -a x"$USER_ID" != x"1001" ]; then

    NSS_WRAPPER_PASSWD=/tmp/passwd.nss_wrapper
    NSS_WRAPPER_GROUP=/etc/group

    cp /etc/passwd $NSS_WRAPPER_PASSWD
    echo "default:x:${USER_ID}:${GROUP_ID}:Default:${HOME}:/sbin/nologin" >> $NSS_WRAPPER_PASSWD

    export NSS_WRAPPER_PASSWD
    export NSS_WRAPPER_GROUP
    export LD_PRELOAD=libnss_wrapper.so
fi

# If no arguments are given to run, then start our little init script
# to kick off nginx and uwsgi
if [ -z "$@" ]; then
    exec $SETUP_DIR_SBIN/tini -- "$SETUP_DIR_BIN/init.sh"
fi

# Otherwise run the argument given on the docker command line (e.g. "bash")
exec $SETUP_DIR_SBIN/tini -- "$@"
