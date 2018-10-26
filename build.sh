#!/bin/sh

set -e

docker build -t xrdp-ubuntu xrdp-ubuntu
docker build -t xrdp-dbus-ubuntu xrdp-dbus-ubuntu
