#!/usr/bin/python3

# USAGE EXAMPLE: $0 -y=2018 -m=5

from datetime import date
from datetime import datetime
from datetime import date
import calendar
import argparse
import sys
from workalendar.europe import Hesse

parser = argparse.ArgumentParser()
parser.add_argument("-m", "--month", action="store", help="month")
parser.add_argument("-y", "--year", action="store", help="year")
args = parser.parse_args()

year = int(args.year)
month = int(args.month)

cal = Hesse()

print("Working days in " + str(month) + "/" + str(year) + ": \n")

for day in range(1,32):
  try:
    if cal.is_working_day(date(year, month, day)):
      t = datetime(year, month, day)
      d = t.weekday()
      print(str(day) + ". (" + calendar.day_name[d] + ")")
  except ValueError:
    pass



