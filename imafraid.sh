#!/bin/sh

# imafraid - simple shell script to update a DynDNS url at afraid.org
# on OpenWRT routers, put this script in /etc/hotplug.d/iface/ and
# simply replace the URL with your update URL (see "Direct URL" under "dynamic update candidates" @ afraid.org)

# written by Armin <netzverweigerer@github>

# empty log:                    
echo " " > /tmp/imafraid.log

# let's do it:                           
if [ "$ACTION" == "ifup" ]; then
  if [ "$DEVICE" == "pppoe-wan" ]; then
    echo "$(date)" >> /tmp/imafraid.log
    echo "env start" >> /tmp/imafraid.log
    env >> /tmp/imafraid.log
    echo "env end" >> /tmp/imafraid.log
    wget -O - "http://freedns.afraid.org/dynamic/update.php?AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==" 2>&1 >/tmp/imafraid.log
  fi
fi
