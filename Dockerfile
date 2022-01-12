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

LABEL original_developer="Arne Schubert <atd.schubert@gmail.com>"
LABEL contributor="Just van den Broecke <justb4@gmail.com>"

# Build ARGS
ARG TZ="Europe/Amsterdam"
ARG LOCALE="en_US.UTF-8"
# Only adds 1MB and handy tools
ARG ADD_DEB_PACKAGES="curl xsltproc libxml2-utils patch"
ARG ADD_PIP_PACKAGES=""
ARG MAPPROXY_VERSION="1.13.2"

# ENV settings
ENV MAPPROXY_PROCESSES="4" \
	MAPPROXY_THREADS="2" \
	UWSGI_EXTRA_OPTIONS="" \
	DEBIAN_FRONTEND="noninteractive" \
	DEB_BUILD_DEPS="python3-pip build-essential python3-dev python3-setuptools python3-wheel" \
	DEB_PACKAGES="python3-pil python3-yaml python3-gdal libproj13 python3-lxml python3-shapely libgeos-dev uwsgi-plugin-python3 ${ADD_DEB_PACKAGES}" \
	PIP_PACKAGES="uwsgi requests geojson MapProxy==${MAPPROXY_VERSION} ${ADD_PIP_PACKAGES}"

RUN set -x \
  && apt-get update \
  && apt-get install --no-install-recommends -y ${DEB_BUILD_DEPS} ${DEB_PACKAGES} ${ADD_DEB_PACKAGES} \
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
COPY patches/ /patches
RUN cd /patches && ./apply.sh && cd -

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mapproxy"]

USER mapproxy

# Why needed? See examples.
# VOLUME ["/mapproxy"]
EXPOSE 8080
# Stats
EXPOSE 9191
