#!/bin/sh

# ensure certificates etc are generated
dpkg-reconfigure xrdp >/dev/null 2>&1

# create user if needed and given
if [ -n "$XRDP_USER" ]; then
  XRDP_USER_HOME="${XRDP_USER_HOME:-/home/$XRDP_USER}"
  getent passwd "$XRDP_USER" >/dev/null 2>&1 || \
    adduser --quiet --disabled-password --shell /bin/bash --gecos "$XRDP_USER" --home "$XRDP_USER_HOME" "$XRDP_USER" && \
    echo "$XRDP_USER:${XRDP_USER_PASSWD:-$XRDP_USER}" | /usr/sbin/chpasswd
  chown "$XRDP_USER:$XRDP_USER" "$XRDP_USER_HOME"
  if $(find "$XRDP_USER_HOME" | wc -l) = 1; then
    su -c "cp -rp /etc/skel/.??* '$XRDP_USER_HOME/'" "$XRDP_USER"
  fi
  unset XRDP_USER
  unset XRDP_USER_HOME
  unset XRDP_USER_PASSWD
fi

mkdir -p /var/run/dbus
chown root:root /var/run/dbus
chmod 0775 /var/run/dbus

if [ -e /etc/dconf/db/local.d ]; then
  dconf update
fi

exec "$@"
