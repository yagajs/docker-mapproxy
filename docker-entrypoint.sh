#!/bin/sh
set -e

if [ "$1" = 'mapproxy' ]; then
  echo "Running additional provisioning"
  for f in /docker-entrypoint-initmapproxy.d/*; do
    case "$f" in
      */*.sh)     echo "$0: running $f"; . "$f" ;;
      */mapproxy.yml)   cp /docker-entrypoint-initmapproxy.d/mapproxy.yml /mapproxy/mapproxy.yaml ;;
      */mapproxy.yaml) cp /docker-entrypoint-initmapproxy.d/mapproxy.yaml /mapproxy/mapproxy.yaml ;;
    esac
    echo
  done

  if [ ! -f /mapproxy/mapproxy.yaml ] ;then
    mapproxy-util create -t base-config /mapproxy/
  fi
  if [ ! -f /mapproxy/app.py ] ;then
    mapproxy-util create -t wsgi-app -f /mapproxy/mapproxy.yaml /mapproxy/app.py
  fi

  # --wsgi-disable-file-wrapper is required because of https://github.com/unbit/uwsgi/issues/1126
  # Note: JvdB June 30, 2020: seems fixed but need Debian Bullseye:
  # https://github.com/unbit/uwsgi/pull/2069, --wsgi-disable-file-wrapper even gives startup-error in Debian Bullseye...
  # Also to wait for Bullseye: --plugin /usr/lib/uwsgi/plugins/python3_plugin.so
  UWSGI_PROTO="http-socket"
  if [ "$2" = 'http' ]; then
    UWSGI_PROTO="http"
  fi
  echo "Start MapProxy with $MAPPROXY_PROCESSES processes and $MAPPROXY_THREADS threads, proto=$UWSGI_PROTO"
  exec uwsgi \
       --plugin /usr/lib/uwsgi/plugins/python3_plugin.so \
       --$UWSGI_PROTO 0.0.0.0:8080 \
       --wsgi-file /mapproxy/app.py \
       --master \
       --enable-threads \
       --processes $MAPPROXY_PROCESSES \
       --threads $MAPPROXY_THREADS \
       --stats 0.0.0.0:9191
  exit
fi

exec "$@"
