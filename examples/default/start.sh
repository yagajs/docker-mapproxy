#!/bin/bash

mkdir -p mapproxy
docker-compose rm --force --stop
docker-compose up -d
