#!/bin/bash
set -x
patch /usr/local/lib/python3.7/dist-packages/mapproxy/srs.py srs-iter.patch
