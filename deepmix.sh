#!/bin/sh

# plays a random mix set from deepmix.eu

a="$(curl http://deepmix.eu/select-e.php | grep mp3 | cut -d'"' -f 2 | shuf | tail -n 1)"; echo "=== $a ==="; mpg123 -C -v "$a"
