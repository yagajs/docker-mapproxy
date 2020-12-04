#!/bin/bash

mkdir -p cache
docker-compose rm --force --stop
docker-compose up -d
