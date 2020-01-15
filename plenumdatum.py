#!/usr/bin/python3

# Plenumdatum v0.1 - by barfoos

import calendar
import datetime

currentYear = datetime.datetime.today().timetuple()[0]
currentMonth = datetime.datetime.today().timetuple()[1]
currentDay = datetime.date.today().timetuple()[2]
monthRange = calendar.monthrange(currentYear,currentMonth)[1]

def getWeekdayFromDate(year, month, day):
    ans = datetime.date(year, month, day)
    return ans.strftime("%A")

def getWeekdayOfLastDayInMonth():
    return getWeekdayFromDate(currentYear, currentMonth, monthRange)

LastWeekdayOfCurrentMonth = getWeekdayOfLastDayInMonth()

tempVar = monthRange

while True:
    if getWeekdayFromDate(currentYear, currentMonth, tempVar) == "Tuesday":
        break
    else:
        tempVar = tempVar - 1

print("Das allmonatliche Chaos Darmstadt e.V. Plenum ist diesen Monat am: " + str(tempVar) + ". ")

