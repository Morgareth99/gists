#!/bin/bash

echo "checking http return code for: $1"

curl -o /dev/null --silent --head --write-out '%{http_code}\n' "$1"


