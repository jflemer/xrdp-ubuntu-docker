FROM ubuntu:cosmic

RUN apt-get update && apt-get install -y --no-install-recommends \
    supervisor \
    x11-apps \
    xorgxrdp \
    xrdp \
  && rm -rf /var/lib/apt/lists/* \
  && rm /etc/xrdp/rsakeys.ini /etc/xrdp/*.pem /etc/ssl/*/ssl-cert-snakeoil.* \
  && update-alternatives --install /usr/bin/x-terminal-emulator \
    x-terminal-emulator /usr/bin/oclock -999

COPY supervisor/ /etc/supervisor/

COPY bin/ /usr/bin/

ENV XRDP_PORT=3389

EXPOSE 3389

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

CMD ["supervisord"]
