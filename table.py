#!/usr/bin/python3
# vim:ft=python ts=4 sw=4 sts=4 et

# table.py - Simple python script that dynamically formats an ascii art table where
# each table cell holds an integer number (incremented, per cell).

# This is a typical excercise task coding lesson for new workers and I just
# wanted to see how bad I perform on this task.

# Written by Armin (Github: netzverweigerer)
# Thu Jan 22 16:15:24 CET 2015


# Table class to hold all our stuff
class Table(object):
    # constructor method, asks for number of rows/columns and
    # initiates empty variable/list states
    def __init__(self):
        print("")
        print("Please enter number of columns: ", end="")
        columns = input()
        self.columns = int(columns)
        print("Please enter number of rows: ", end="")
        rows = input()
        print("")
        self.dimensions = (columns,rows)
        self.lines = []
        self.rows = int(rows)
        self.total = self.rows * self.columns
        self.maxlength = len(str(self.total))
        self.currentrow = 0
        self.maxlinelength = 0
        self.outputlines = []
        self.resultlines = []

    # pad number with leading zeroes (or spaces)
    def pad(self,number):
        return format(number,str(self.maxlength)).replace(' ',' ')
        # return format(number,str(self.maxlength)).replace(' ','0')

    # build row with line drawing characters and numbers
    def buildrow(self,row):
        line = "|" 
        for number in range(1,self.columns + 1):
            number = number + (row * (self.columns))
            line = line + " " + self.pad(number) + " " + "|"
        return line

    # build basic table layout by building each row and
    # appending it to the "lines" list object
    def buildtable(self):
        for row in range(0,self.rows):
            r = self.buildrow(row)
            self.lines.append(r)

    # go through all lines and update the maximum length of line variable 
    def updatemaxlengthofline(self):
        for line in self.lines:
            length = len(line)
            if length > self.maxlinelength:
                self.maxlinelength = length

    # returns a nicely formatted header
    def getheader(self):
        r = ","
        for char in range(1,self.maxlinelength - 1):
            r = r + '-'
        r = r + '.'
        return r

    # returns a nicely formatted footer
    def getfooter(self):
        r = '`'
        for char in range(1,self.maxlinelength - 1):
            r = r + '-'
        r = r + '´'
        return r

    # returns a nicely formatted horizontal seperator line
    def getseperator(self):
        chars = ''
        for char in range(0,self.maxlinelength):
            chars += '-'
        return chars

    # add header, table lines, seperators and footer to the "resultlines" list
    def buildresultlines(self):
        self.resultlines.append(self.getheader())
        for line in self.lines:
            self.resultlines.append(line)
            self.resultlines.append(self.getseperator())
        self.resultlines = self.resultlines[:-1]
        self.resultlines.append(self.getfooter())

    # finally print lines from "resultlines" list, displaying a beautly table
    def printresultlines(self):
        for line in self.resultlines:
            print(line)

# build table object:
a = Table()

# run class methods necessary to properly build the ascii table
a.buildtable()
a.updatemaxlengthofline()
a.buildresultlines()

# print the resulting table
a.printresultlines()



