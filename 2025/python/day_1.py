#!/usr/bin/env python3
import sys
import numpy as np

# convert input into array of (signed) ints
parse = lambda x: int(x[1:]) if x[0] == "R" else -int(x[1:])
i = np.genfromtxt(sys.argv[1], delimiter="\n", converters={0: parse})

# part 1 count zeros in landed positions
x = 50 + np.cumsum(i)
y = np.mod(x, 100)
p1 = len(np.where(y == 0)[0])
print("Part 1: ", p1)

# part 2 count zeros through every rotation 
yi = np.insert(y[:-1], 0, 50)
m = yi + i
n = np.floor_divide(np.abs(m), 100) # count full revolutions
n[(n > 0) & (y == 0)] -= 1 # avoid double counting landed zeros
t = (m < 0) & (yi > 0) # count sign changes
p2 = p1 + np.sum(t + n)
print("Part 2: ", p2)
