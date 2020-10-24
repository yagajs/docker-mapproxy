# MapProxy for Docker

![GitHub license](https://img.shields.io/github/license/justb4/docker-mapproxy)
![GitHub release](https://img.shields.io/github/release/justb4/docker-mapproxy.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/justb4/mapproxy.svg)

MapProxy Docker Image from the [YAGA Development-Team](https://yagajs.org).
Adapted by [justb4](https://github.com/justb4) to latest MP version, small Docker image and extended examples.
Find image on [Docker Hub](https://hub.docker.com/repository/docker/justb4/mapproxy).

## Supported tags

* `1.12.0`, `1.12`, `1`, `latest`

## What is MapProxy

[MapProxy](https://mapproxy.org/) is an open source proxy for geospatial data. It caches, accelerates and transforms
data from existing map services and serves any desktop or web GIS client.

## Run container

See the examples, these use `docker-compose`, more convenient than `docker run` commands:

* [default](examples/default) - default out-of-the-box example
* [standard](examples/standard) - mapproxy [config](examples/standard/config/mapproxy.yaml) with some facilities like GeoPackage tile cache, custom grid etc

The second example should give you a nice starter.

But you can run the container with standard `docker`:

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
* `UWSGI_EXTRA_OPTIONS` extra `uwsgi` commandline options e.g. `"--disable-logging --stats 0.0.0.0:9191"`, default empty

## Seeding

The image also allows arbitrary commands like seeding:

```bash 

docker exec -it mapproxy mapproxy-seed -f /mapproxy/mapproxy.yaml -s /mapproxy/seed.yaml --seed myseed1

```

## Enhance the image

You can put a `mapproxy.yaml` into the `/docker-entrypoint-initmapproxy.d` folder on the image. On startup this will be
used as MapProxy configuration. Attention, this will override an existing configuration in the volume!

Additional you can put shell-scripts, with `.sh`-suffix in that folder. They get executed on container startup.

You should use the `mapproxy` user within the container, especially not `root`!

You can also add extra packages in build args: `ADD_DEB_PACKAGES` and `ADD_PIP_PACKAGES`.

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull
requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a
[GitHub issue](https://github.com/yagajs/docker-mapproxy/issues), especially for more ambitious contributions.
This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help
you find out if someone else is working on the same thing.

## License

This project is published under [ISC License](LICENSE).
