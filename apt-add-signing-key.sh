#!/bin/bash

# apt-add-signing-key - adds a new GPG key to apt-key that is being used for signing packages to be installed
# Usage: apt-add-signing-key <Key-ID>

id="$1"
length="$(echo -n "$id" | wc -c)"
echo "$length"

if [[ "$length" == 16 ]]; then
  echo "id has 16 characters"
  sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com "$id"
else
  echo "id not recognized"
  exit 1
fi

