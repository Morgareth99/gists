#!/usr/bin/python2

import os
import datetime
import datetime

def convertTimestampToDate(timestamp):
  return datetime.datetime.fromtimestamp(int(timestamp)).strftime('%Y-%m-%d %H:%M:%S')

subdirs = [d for d in os.listdir('.') if os.path.isdir(d)]
latest_subdir = max(subdirs, key=os.path.getmtime)

print type(subdirs)

d = {}
for dir in subdirs:
  mtime = os.path.getmtime(dir)
  d[dir] = mtime

# sorted dictionary, sorted by mtime
s = sorted([(value,key) for (key,value) in d.items()])

for key, value in s:
  print "Time: " + convertTimestampToDate(key)
  print "Name: " + value
  print "--"

# print s



