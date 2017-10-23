# Mapproxy for Docker

MapProxy docker image from the [YAGA Development-Team](https://yagajs.org)

## Supported tags

* `1.10.4`, `1.10`, `1`, `latest`
* `1.10.4-alpine`, `1.10-alpine`, `1-alpine`, `alpine`
* `1.10.3`
* `1.10.3-alpine`
* `1.10.2`
* `1.10.2-alpine`
* `1.10.1`
* `1.10.1-alpine`
* `1.10.0`
* `1.10.0-alpine`
* `1.9.1`, `1.9`
* `1.9.1-alpine`, `1.9-alpine`
* `1.9.0`
* `1.9.0-alpine`
* `1.8.2`, `1.8`
* `1.8.2-alpine`, `1.8-alpine`
* `1.8.1`
* `1.8.1-alpine`
* `1.8.0`
* `1.8.0-alpine`
* `1.7.1`, `1.7`
* `1.7.1-alpine`, `1.7-alpine`
* `1.7.0`
* `1.7.0-alpine`

## What is MapProxy

[MapProxy](https://mapproxy.org/) is an open source proxy for geospatial data. It caches, accelerates and transforms
data from existing map services and serves any desktop or web GIS client.

## Run container

You can run the container with a command like this:

```bash
docker run -v /path/to/mapproxy:/mapproxy -p 8080:8080 yagajs/mapproxy
```

*It is optional, but recommended to add a volume. Within the volume mapproxy get the configuration, or create one
automatically. Cached tiles will be stored also into this volume.*

The container normally runs in [http-socket-mode](http://uwsgi-docs.readthedocs.io/en/latest/HTTP.html). If you will not
run the image behind a HTTP-Proxy, like [Nginx](http://nginx.org/), you can run it in direct http-mode by running:

```bash
docker run -v /path/to/mapproxy:/mapproxy -p 8080:8080 yagajs/mapproxy mapproxy http
```

### Environment variables

* `MAPPROXY_PROCESSES` default: 4
* `MAPPROXY_THREADS` default: 2

## Enhance the image

You can put a `mapproxy.yaml` into the `/docker-entrypoint-initmapproxy.d` folder on the image. On startup this will be
used as MapProxy configuration. Attention, this will override an existing configuration in the volume!

Additional you can put shell-scripts, with `.sh`-suffix in that folder. They get executed on container startup.

You should use the `mapproxy` user within the container, especially not `root`!

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull
requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a
[GitHub issue](https://github.com/yagajs/docker-mapproxy/issues), especially for more ambitious contributions.
This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help
you find out if someone else is working on the same thing.
