#!/usr/bin/python
import dbm
db = dbm.open('cache', 'c')
db['www.yahoo.com'] = 'YAHOOOOOOOOOOOOOOOOOO'
print db.get('www.yahoo.com')
db.close()



