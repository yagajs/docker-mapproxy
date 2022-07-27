# What this solves
In some cases the demo page renders with 'internal error'
See issue: https://github.com/mapproxy/mapproxy/issues/430
Error in uwsgi output

Update: fixed by https://github.com/mapproxy/mapproxy/pull/420
And in 1.13.2 version. Skipping in [apply.sh](apply.sh), but keeping the fix if ever needed.

# commands

``` 
diff -u srs-1.12.0.py srs-master.py > srs-iter.patch
patch /usr/local/lib/python3.7/dist-packages/mapproxy/srs.py srs-iter.patch

```