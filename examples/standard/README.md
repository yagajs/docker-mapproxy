# Example - Standard

A more standard example more matching real-life use.
It uses:

* Open Dutch Aerial maps
Uses `docker-compose`.

How to use:

```
./build.sh
./start.sh
browse to http://localhost:8085/demo/?tms_layer=dutch_aerial&format=jpeg&srs=EPSG%3A28992
./stop.sh
``` 

The local directory `./config` will be mapped to the MP Container `/mapproxy` dir.
The `cache` directory will be mapped to the `/mapproxy_cache` dir.

## Alternaive

Using `docker run`:

```bash 
docker run -v $PWD/config:/mapproxy -v $PWD/cache:/mapproxy_cache -p 8085:8080 justb4/mapproxy mapproxy http

```
## Seeding

The image also allows arbitrary commands like seeding:

Un running container:

```bash 

docker exec -it mapproxy mapproxy-seed -f /mapproxy/mapproxy.yaml -s /mapproxy/seed.yaml --seed myseed1

```

or standalone

```bash
docker run -v $PWD/config:/mapproxy -v $PWD/cache:/mapproxy_cache -p 8085:8080 justb4/mapproxy \
           mapproxy-seed -f /mapproxy/mapproxy.yaml -s /mapproxy/seed.yaml --seed myseed1
```
