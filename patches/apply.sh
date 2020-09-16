#!/bin/bash
for patch in "srs-iter"
do
  cd ${patch}
  ./apply.sh
  cd -
done
