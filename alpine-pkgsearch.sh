#!/bin/sh
# 
# Searches for Alpine Linux packages containing <filename>
# Written by Armin <armin@FreeNode>, released under the terms of the WTFPL.
# 
# Credit and kudos to qman for pointing out the curl oneliner (thanks!)
# 

bailout () {
  echo "$@"
  exit 1
}

usage () {
  echo "USAGE: $0 <filename>"
  exit 255
}

hash curl >/dev/null 2>&1 || bailout "ERROR: curl not found. Please install curl."

case "$1" in
'')
  usage
;;
*)
  file="${1}"; curl -s "https://pkgs.alpinelinux.org/contents?file=${file}" | grep package | cut -d\> -f3 | cut -d\< -f1 | uniq
;;
esac




