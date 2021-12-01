#!/usr/local/bin/io

input := File standardInput readLines map(line, line asNumber)

a := 0
input foreach(i, v, 
    if(i == 0, p := v) 
    if(v > p, a = a + 1)
    p = v
)

b := 0
for(i, 0, input size,
    if(i + 3 <= input size,
        s := input slice(i, i + 3) sum
        if(i == 0, p := s)
        if(s > p, b = b + 1)
        p = s
    )
)

a println
b println
