FROM xrdp-ubuntu

RUN apt-get update && apt-get install -y \
  dbus-x11 \
  dconf-cli \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/dbus && chmod 0755 /var/run/dbus

COPY supervisor/ /etc/supervisor/

COPY dconf/ /etc/dconf/

RUN mkdir -p /etc/dconf/db/local.d && dconf update
