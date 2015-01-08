#!/bin/sh

cat ./clean-packages.db|awk '{print "dep('"'"'"$1"'"'"', '"'"'"$2"'"'"')."}'
