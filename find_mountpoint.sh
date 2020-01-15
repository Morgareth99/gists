#!/bin/bash

function usage() {
  echo "Usage: $0 <file1> ... <fileN>"
  echo "        prints the mountpoint along with actual device for each argument."
}

if [[ "$#" -lt 1 ]]; then usage; fi

for arg in "$@"; do
  d="$(df -P "$arg" | tail -1 | cut -d" " -f 1)";
  m="$(df -P "$arg" | tail -1 | sed 's/ \+/ /g' | cut -d" " -f 6-)"
  echo "$arg :: $d :: $m"
done
