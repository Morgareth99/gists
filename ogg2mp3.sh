#!/bin/bash

# vim:ft=zsh ts=2 sw=2 sts=2 et

# Simple script to convert OGG to MP3
# http://github.com/netzverweigerer
# Usage: ogg2mp3 <file1> [<file2> <file3> ...]

# Set options for LAME encoder
# vbr, ~192k:
# lame_opts="--vbr-new -V 2 -b 192 "
# cbr, 320k:
lame_opts="--cbr -b 320 "

function dep_exit () {
    echo "Depency not found: $@"
    exit 1
}

for dep in oggdec lame dirname; do
    which "$dep" >/dev/null 2>&1 || dep_exit "$dep"
done

for x in "${@}"; do
    echo "Performing: $x"
    OGG="${x}"
    MP3=`basename "${OGG%.ogg}.mp3"`
    [ -r "$OGG" ] || { echo can not read file \"$OGG\" >&1 ; exit 1 ; } ;
    TITLE="`ogginfo "$OGG" | grep TITLE= | cut -d"=" -f 2-`"
    ALBUM="`ogginfo "$OGG" | grep ALBUM= | cut -d"=" -f 2-`"
    TRACKNUMBER="`ogginfo "$OGG" | grep TRACKNUMBER= | cut -d"=" -f 2-`"
    ARTIST="`ogginfo "$OGG" | grep ARTIST= | cut -d"=" -f 2-`"
    GENRE="`ogginfo "$OGG" | grep GENRE= | cut -d"=" -f 2-`"
    COMMENT="`ogginfo "$OGG" | grep COMMENT= | cut -d"=" -f 2-`"
    DATE="`ogginfo "$OGG" | grep DATE= | cut -d"=" -f 2-`"
    # pipe oggdec output to lame encode and create mp3:
    dir="$(dirname "$OGG")"
    oggdec -o /tmp/tmpfile.ogg2mp3 "$OGG"
    lame ${lame_opts} --tt "$TITLE" --tn "$TRACKNUMBER" --tg "$GENRE" --ty "$DATE" --ta "$ARTIST" --tl "$ALBUM" --add-id3v2 /tmp/tmpfile.ogg2mp3 "${dir}/${MP3}"
done
