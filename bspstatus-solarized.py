#!/usr/bin/python
# -*- coding: utf-8 -*-
# bspstatus solarized - <armin@mutt.email>
# a simple dzen2 status line script with solarized like colors
import psutil
import sys
import time
import os
class bspstatus(object):
    def __init__(self):
        self.text = ""
        self.fg = '#887744'
        self.warning = '#999966'
        self.critical= '#bb6666'
        self.wifi = '#556666'
        self.mpd = '#558866'
        self.battery = '#778888'
        self.discharging = '#776685'
        self.workspace_color = '#667777'
    def add(self,line):
        line = str(line)
        if "no identities" in line:
          line = '^fg(' + self.critical + ')' + line
        if "Workspace" in line:
          line = '^fg(' + self.workspace_color + ')' + line
        if "warning" in line:
          line = '^fg(' + self.warning+ ')' + line
        if "MPD" in line or "mpd" in line:
          line = '^fg(' + self.mpd + ')' + line
        if "critical" in line or "not connected" in line:
          line = '^fg(' + self.critical + ')' + line
        if "wifi" in line:
          line = '^fg(' + self.wifi + ')' + line
        if "Battery" in line:
          if "discharging" in line or "Discharging" in line:
            line = '^fg(' + self.discharging + ')' + line
          else:
            line = '^fg(' + self.battery + ')' + line
        self.text = self.text + line
    def get(self):
        print(self.text.strip())
    def sep(self):
        self.text = self.text + '^fg(#aa3333)^bg(#081b26) Â» ^fg(' + self.fg + ")"
        # self.text = self.text + '^fg(#ff3333) :: ^fg(' + self.fg + ")"

class info(object):
    def __init__(self):
        pass
    def run(self,command):
        import subprocess
        command = command.split(' ')
        proc = subprocess.Popen(command, stdout=subprocess.PIPE)
        out = proc.communicate()[0]
        return str(out)
    def cpu(self):
        usage = psutil.cpu_percent()
        if usage > 25:
            cpu = 'CPU: ' + str(usage) + "%" + " (warning)"
        if usage > 60:
            cpu = 'CPU: ' + str(usage) + "%" + " (critical)"
        else:
            cpu = 'CPU: ' + str(usage) + "%"
        return cpu 
    def mem(self):
        mem = str(psutil.phymem_usage()).split('(')[1].split(')')[0].split(',')
        for e in mem:
            f = e.strip()
            if f.startswith("percent"):
                p = str(f).split("=")[1]
                i = int(p.split('.')[0])
                if i > 70:
                    r = "Mem: " + p + "%" + " (warning)"
                if i > 85:
                    r = "Mem: " + p + "%" + " (critical)"
                else:
                    r = "Mem: " + p + "%" + " "
                return r
    def disk(self,mountpoint):
        mem = str(psutil.disk_usage(mountpoint)).split('(')[1].split(')')[0].split(',')
        for e in mem:
            f = e.strip()
            if f.startswith("percent"):
                p = str(f).split("=")[1] + '%'
                i = int(p.split('.')[0])
                if i > 80:
                    p = p + " (warning)"
                if i > 90:
                    p = p + " (critical)"
                r = "Disk: " + p 
                return r
    def workspace(self):
        workspace = int(self.run('xprop -root _NET_CURRENT_DESKTOP').split("=")[1].split('\\')[0]) + 1
        return('Workspace: ' + str(workspace))
    def date(self):
        out = self.run('date')
        a = str(out).strip().split( )[3]
        b = a[0:5]
        return b
    def fob(self):
        output = self.run('/home/armin/bin/fob list').strip()
        return output
    def wt(self):
        output = self.run('/home/armin/bin/wt').strip()
        return output
    def bat(self):
        output = "Battery: " + self.run('/home/armin/bin/bat').strip()
        return output
    def wifi(self):
        try:
            output = self.run('iwconfig wlan0').split('\n')
            for line in output:
                if "ESSID:" in line:
                    return "wifi: " + line.split('"')[1] 
                    break
            return "wifi: disconnected"
        except:
            return "not connected"
    def mpdpi(self):
        try:
            output = self.run('mpc -h pi').split('\n')
            if output[0].startswith('volu'):
                o = "MPD@pi not playing."
            else:
                for line in output:
                    if line.startswith('volume'):
                        try:
                          volume = "[V: " + line.split('%')[0].split(' ')[1] + "]"
                        except: 
                          volume = "[V: 100]"
                l = len(output[0])
                if l > 50:
                    o = "MPD: " + output[0][:48] + " ... " + volume
                else:
                    o = "MPD: " + output[0] + " " + volume
            return o
        except:
            return "MPD@pi not reachable."


while True:
    b = bspstatus()
    i = info()

    b.sep()

    workspace = i.workspace()
    b.add(workspace)

    b.sep()

    wt = i.wt()
    b.add(wt)

    b.sep()

    cpu = i.cpu()
    b.add(cpu)

    b.sep()

    mem = i.mem()
    b.add(mem)

    b.sep()

    disk = i.disk('/')
    b.add(disk)

    b.sep()

    fob = i.fob()
    b.add(fob)

    b.sep()

    wifi= i.wifi()
    b.add(wifi)

    b.sep()

    mpdpi= i.mpdpi()
    b.add(mpdpi)

    b.sep()

    bat = i.bat()
    b.add(bat)

    b.sep()

    date = i.date()
    b.add(date)

    b.sep()


    b.get()
    sys.stdout.flush()
    time.sleep(1)








