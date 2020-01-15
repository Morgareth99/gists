#!/bin/sh
#
# Rebuilds WORLD and KERNEL on a FreeBSD system to
# follow the FreeBSD STABLE release branch.
#
# This script attempts to automate the task of rebuilding an entire system
# stack of a FreeBSD machine (src / ports, respectively). It obtains a fresh
# clone of both /usr/src and /usr/ports via svn (Subversion), then rebuilds
# world and the kernel using a copy of the GENERIC kernel configuration file
# using the upper-cased version of the hostname of the machine. It will also
# guide the user through those tasks, so minimizes the effects of human error.
#
##############################################################################
### Copyright (c) <2016> Armin <a@m2m.pm>, released under the terms of the ###
### MIT BSD like license                                                   ###
##############################################################################
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set -e

kernconf="$(a="$(hostname)"; b="$(echo "${a%%.*}" | tr '[:lower:]' '[:upper:]')"; echo "$b")"
echo "KERNCONF: $kernconf"

arch="amd64"
release="11"

bailout () {
  echo -n "${0}: Error: "
  echo "$@"
  exit 1
}

if [ -e /usr/src ]; then
  echo "=== Updating /usr/src via SVN ..."
  cd /usr/src
  svn up
  cd -
  #bailout "/usr/src exists. Exiting gracefully. Please rename that directory first, then call ${0} again."
else
  echo "=== SVN: obtaining fresh clone of /usr/src ..."
  svn checkout https://svn0.us-west.freebsd.org/base/stable/${release} /usr/src
fi

if [ -e /usr/ports ]; then
  echo "=== Updating /usr/ports via SVN ..."
  cd /usr/ports
  svn up
  cd -
  #bailout "/usr/ports exists. Exiting gracefully. Please rename that directory first, then call ${0} again."
else
  echo "=== SVN: obtaining fresh clone of /usr/ports ..."
  svn checkout https://svn0.us-west.freebsd.org/ports/head /usr/ports
fi

if [ -e /usr/src/sys/amd64/conf/${kernconf} ]; then
  echo "=== Using existing kernel configuration file $kernconf"
else
  echo "=== Generating new kernel configuration file $kernconf (based on GENERIC)..."
  cat /usr/src/sys/amd64/conf/GENERIC | sed "s/GENERIC/${kernconf}/g" > /usr/src/sys/amd64/conf/${kernconf}
fi

cd /usr/src

echo ">>> Building WORLD..."
make buildworld -j4

echo ">>> Building KERNEL (${kernconf})..."
make buildkernel KERNCONF=${kernconf}

echo ">>> Installing KERNEL (${kernconf})..."
make installkernel KERNCONF=${kernconf}

echo
echo ">>> [installkernel] completed."
echo
echo "=== It's time to reboot and run \"make installworld\" now. ==="
echo
echo "NOTE: You'll have to reboot after installing the new world distribution:"
echo
echo "[reboot]"
echo "# cd /usr/src"
echo "# make installworld KERNCONF=BASE"
echo "[reboot]"
echo "# echo 'hooray'"
echo ""

exit 0


