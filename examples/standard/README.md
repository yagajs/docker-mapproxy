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

The local directory `./config` will be mapped to the MP Container `/mapproxy` dire.
The `cache` directly will be