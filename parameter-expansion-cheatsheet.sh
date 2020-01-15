#!/bin/bash

name="polish.ostrich.racing.champion"

echo "$name"

echo -n '${name#*.}: '
echo "${name#*.}"
echo -n '${name##*.}: '
echo "${name##*.}"
echo -n '${name%%.*}: '
echo "${name%%.*}"
echo -n '${name%.*}: '
echo "${name%.*}"


