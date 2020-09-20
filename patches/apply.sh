#!/bin/bash
for patch in $(ls)
do
  if [ -d "${patch}" ]
  then
   cd ${patch} && ./apply.sh && cd -
  fi
done
