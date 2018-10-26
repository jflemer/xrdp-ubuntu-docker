#!/bin/sh

dpkg-reconfigure xrdp >/dev/null 2>&1

exec /usr/sbin/xrdp "$@"
