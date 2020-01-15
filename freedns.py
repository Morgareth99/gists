#!/usr/bin/python3

# Prints a list of DNS servers run by opennicproject.org, an open and
# democratic DNS provider

# written by Armin J. (netzverweigerer@github)

import requests
import ipaddress
import re

a = requests.get('http://opennicproject.org')
b = a.text
b = b.replace('&nbsp;',' ')
c = b.split('\n')

def parseline(text):
    for word in text.split():
        try:
            a = ipaddress.ip_address(word)
        except ValueError:
            pass
        else:
            print(word)

m = 0
for line in c:
    if 'Give me the numbers' in line:
        m = 1
    if m == 1:
        ip_regex = re.findall(r'(?:\d{1,3}\.){3}\d{1,3}', line)
        if not ip_regex == []:
            s = ip_regex
            for i in s:
                print(i)
    if 'Freenode' in line:
        m = 0



