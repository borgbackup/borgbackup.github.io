#!/bin/sh
# Enable job control
set -m
# Launch local web server in background
(python -m http.server --bind 127.0.0.1 > /dev/null 2>&1) &
xdg-open http://127.0.0.1:8000/
watch -n 1 make all
# When ^C is hit, watch is terminated; terminate the background job as well.
kill %1