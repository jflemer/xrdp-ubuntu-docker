xrdp-ubuntu-docker
==================

Some base images for running X Windows / X11 applications or sessions in docker. Provides the minmal functional Xrdp structure.

Images
------

### `xrdp-ubuntu`

Runs `xrdp` and `xrdp-sesman` via `supervisord`.

### `xrdp-dbus-ubuntu`

Extends the above to also run a system DBus instance from `supervisord`. If you want/need DBus, you probably also want to use `dbus-run-session` when you extend from this container.

Build
-----

    docker build -t xrdp-ubuntu xrdp-ubuntu
    docker build -t xrdp-dbus-ubuntu xrdp-dbus-ubuntu

Environment
-----------

| Variable           | Default            | Description |
| ------------------ | ------------------ | ----------- |
| `XRDP_PORT`        | `3389`             | TCP port for Xrdp |
| `XRDP_USER`        | *unset*            | If set, create a local user with this name |
| `XRDP_USER_PASSWD` | `$XRDP_USER`       | Password for user |
| `XRDP_USER_HOME`   | `/home/$XRDP_USER` | Home directory for user |

Configure / Extend
------------------

### Application

Xrdp-sesman calls /etc/X11/Xsession. See the [Debian wiki for Xsession](https://wiki.debian.org/Xsession) to configure application and/or session startup.

Either extend this base image, or volume mount content for Xsession.

This image uses `update-alternatives` to set `x-terminal-emulator` to `oclock` with a priority of `-999`. So lacking any other configuration, the session will just be a single clock.

### Users

Either use the simplistic (not very secure) environment variable `XRDP_USER`, or exent one of these images and setup user(s) however you like.

Example Execution
-----------------

Run as is with a new user.

    docker run -p 3389:3389 -e XRDP_USER=ubuntu xrdp-ubuntu
    rdesktop -u localhost:3389

Example Extension
-----------------

Create an image that runs `xterm` (via `x-terminal-emulator`):

    FROM xrdp-ubuntu
    RUN apt-get update && apt-get install -y xterm && \
      rm -rf /var/lib/apt/lists/*
    ENV XRDP_USER ubuntu

Create an image that runs `i3` session (via `x-window-manager`):

    FROM xrdp-ubuntu
    RUN apt-get update && apt-get install -y i3 && rm -rf /var/lib/apt/lists/*
    ENV XRDP_USER ubuntu

Create an image that runs a specific application via `x-session-manager`,
login as user `bzflag` and password `bzflag`:

    FROM xrdp-ubuntu
    RUN apt-get update && apt-get install -y bzflag && \
      rm -rf /var/lib/apt/lists/* && \
      update-alternatives --install /usr/bin/x-session-manager \
        x-session-manager /usr/games/bzflag 9999
    ENV XRDP_USER bzflag
