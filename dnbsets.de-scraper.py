#!/usr/bin/python
import requests
a = requests.get('http://www.dnb-sets.de/').text.encode('utf-8').replace('<','\n').split('\n')
for i in a:
    if ".mp3\"" in i:
        print i.split('"')[1]
