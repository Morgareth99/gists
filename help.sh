#!/bin/bash

help () {
  echo "This is a help function message."
}

case "$@" in
  '')
    help
  ;;
  *)
  echo "Wheee, we got arguments."
  ;;
esac



