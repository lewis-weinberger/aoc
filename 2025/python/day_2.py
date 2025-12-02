#!/usr/bin/env python3
import sys
import re

# convert input into flat array of IDs
with open(sys.argv[1], "r") as f:
    i = [
        str(y)
        for x in f.read().split(",")
        for y in range(int(x.split("-")[0]), int(x.split("-")[1]) + 1)
    ]

# regex match on repeated digit patterns
p1, p2 = 0, 0
r1 = re.compile(r"(\d+)\1$")
r2 = re.compile(r"(\d+)\1+$")
for y in i:
    if r1.match(y):
        p1 += int(y)
    if r2.match(y):
        p2 += int(y)
    
print("Part 1: ", p1)
print("Part 2: ", p2)
