FROM debian:buster-slim

# Notes by Just van den Broecke - July 2020
# The original image (from 2019), based on Debian Buster Python3 was around 1GB.
# Slimmed down to 294MB by:
# - using Debian Slim image.
# - Using https://github.com/geopython/pygeoapi/blob/master/Dockerfile as example.
# - avoided building wheels by installing python- packages
# - removing build dependency packages.
#
# Upgrade notes: Debian bullseye-slim (follow up from Buster) has Python 3.8
# Currently compat problem with MP 1.12.0 because of "cgi" packages
# See issue: https://github.com/mapproxy/mapproxy/issues/462
# like wsgi-plugin-python3 (needs to wait)
#
# Upgrade notes: in bullseye: use libproj19 uwsgi-plugin-python3 (i.s.o. pip3 uwsgi)
# --plugin /usr/lib/uwsgi/plugins/python3_plugin.so in uwsgi command and remove --wsgi-disable-file-wrapper
#
# Nasty fix: added Google Web Merc projection EPSG:900913 for legacy MP configs (clients use /EPSG:900913/ in URLs!)
# Upgrade notes: Debian bullseye-slim and proj.6: will need SQLite for proj.db i.s.o. /usr/share/proj/epsg!!

LABEL original_developer="Arne Schubert <atd.schubert@gmail.com>"
LABEL contributor="Just van den Broecke <justb4@gmail.com>"

# Build ARGS
ARG TZ="Europe/Amsterdam"
ARG LOCALE="en_US.UTF-8"
# Only adds 1MB and handy tools
ARG ADD_DEB_PACKAGES="curl xsltproc libxml2-utils"
ARG ADD_PIP_PACKAGES=""
ARG MAPPROXY_VERSION="1.12.0"

# ENV settings
ENV MAPPROXY_PROCESSES="4" \
	MAPPROXY_THREADS="2" \
	DEBIAN_FRONTEND="noninteractive" \
	DEB_BUILD_DEPS="python3-pip build-essential python3-dev python3-setuptools python3-wheel" \
	DEB_PACKAGES="python3-pil python3-yaml python3-gdal libproj13 python3-lxml python3-shapely libgeos-dev uwsgi-plugin-python3 ${ADD_DEB_PACKAGES}" \
	PIP_PACKAGES="uwsgi requests geojson MapProxy==${MAPPROXY_VERSION} ${ADD_PIP_PACKAGES}" \
	GOOGLE_WEB_MERC_EPSG="<900913> +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs <>"

RUN set -x \
  && apt-get update \
  && apt-get install --no-install-recommends -y ${DEB_BUILD_DEPS} ${DEB_PACKAGES} ${ADD_DEB_PACKAGES} \
  && echo ${GOOGLE_WEB_MERC_EPSG} >> /usr/share/proj/epsg \
  && useradd -ms /bin/bash mapproxy \
  && mkdir -p /mapproxy \
  && chown mapproxy /mapproxy \
  && pip3 install ${PIP_PACKAGES} ${ADD_PIP_PACKAGES} \
  && mkdir -p /docker-entrypoint-initmapproxy.d \
  && pip3 uninstall --yes wheel \
  && apt-get remove --purge ${DEB_BUILD_DEPS} -y \
  && apt autoremove -y  \
  && rm -rf /var/lib/apt/lists/*

# RUN sed -i -r 's|^(from )cgi|\1html|g;s|^(import )cgi$|\1html|g;s|^(import )cgi$|\1html|g;s|\{\{cgi(\.escape)|{{html\1|g' /usr/local/lib/python3.8/dist-packages/mapproxy/service/templates/demo/*.html /usr/local/lib/python3.8/dist-packages/mapproxy/service/template_helper.py
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mapproxy"]

USER mapproxy

# Why needed? See examples.
# VOLUME ["/mapproxy"]
EXPOSE 8080
# Stats
EXPOSE 9191
