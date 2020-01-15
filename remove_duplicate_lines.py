#!/usr/bin/env python2

import sys

unique_lines = []
duplicate_lines = []

for line in sys.stdin:
  if line == '\n':
    sys.stdout.write(line)
  elif line in unique_lines:
    duplicate_lines.append(line)
  else:
    unique_lines.append(line)
    sys.stdout.write(line)


