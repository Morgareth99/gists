#!/usr/bin/env python3

import subprocess
import sys
import time

class Link:
    def __init__(self, ifname):
        self.ssid = ""
        self.dhcpcd = None
        self.ifname = str(ifname)

    def is_active(self):
        # return true if link is active
        up_strs = ["active", "associated"]
        cmd = ["ifconfig", self.ifname]
        cmd_result = subprocess.check_output(cmd).decode("utf-8")
        tokens = cmd_result.split()
        for i in range(0, len(tokens)-1):
            if "ssid" == tokens[i]:
                newssid = tokens[i+1]
                if newssid != self.ssid:
                    # ssid changed, assume link down
                    self.ssid = newssid
                    return False
        for i in range(0, len(tokens)-1):
            if "status:" == tokens[i]:
                for up_str in up_strs:
                    if up_str in tokens[i+1]:
                        return True
        return False

    def get_l3addrs(self, af):
        # return list of configured L3 addresses
        l3addrs = []
        cmd = ["ifconfig", self.ifname]
        cmd_result = str(subprocess.check_output(cmd))
        tokens = cmd_result.split()
        for i in range(0, len(tokens)-1):
            if af in tokens[i]:
                l3addrs += [tokens[i+1]]
        return l3addrs

    def clear_l3addrs(self):
        # remove stale L3 addresses
        for af in ["inet6", "inet"]:
            l3addrs = self.get_l3addrs(af)
            for l3addr in l3addrs:
                cmd = ["ifconfig", self.ifname, af, l3addr, "delete"]
                cmd_result = str(subprocess.check_output(cmd))

    def dhcpcd_alive(self):
        # return true if dhcpcd is alive on this interface
        if self.dhcpcd == None:
            return False
        if self.dhcpcd.poll() != None:
            return False
        return True

    def up(self):
        # bring up dhcpcd
        if not(self.dhcpcd_alive()): 
            self.clear_l3addrs()
            cmd = ["dhcpcd", "-d", "-B", self.ifname]
            self.dhcpcd = subprocess.Popen(cmd, stderr=subprocess.PIPE)

    def down(self):
        # take down dhcpcd
        if self.dhcpcd != None:
            if self.dhcpcd.poll() == None:
                self.dhcpcd.terminate()
                self.dhcpcd = None
        self.clear_l3addrs()

class Konnektor:
    def __init__(self, interfaces):
        self.interfaces = []
        for interface in interfaces:
            self.interfaces += [ Link(interface) ]

    def loop(self):
        # the main loop
        while True:
            s = 1
            try:
                for interface in self.interfaces:
                    if s == 1 and interface.is_active():
                        interface.up()
                        s = 0
                    else:
                        interface.down()
            except subprocess.CalledProcessError:
                pass
            time.sleep(1)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        k = Konnektor(sys.argv[1:])
        k.loop()
    else:
        print("usage: " + sys.argv[0] + " <interface> [interface]*")

