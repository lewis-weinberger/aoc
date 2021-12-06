#!/usr/local/bin/io

input := File standardInput readLine split(",") map(c, c asNumber)

reproduce := method(n, cnt, nxt,
    for(i, 0, 8,
        if(i == 8 or i == 6, 
            nxt atPut(i, cnt at(0))
            if(i == 6, nxt atPut(i, nxt at(i) + cnt at(7))),
            nxt atPut(i, cnt at(i + 1))
        )
    )
    nxt foreach(i, v, cnt atPut(i, v))
    return(n + 1)
)

counts := list(0,0,0,0,0,0,0,0,0)
input foreach(v, counts atPut(v, counts at(v) + 1))
next := counts clone
n := 1

while(n <= 80, n = reproduce(n, counts, next))
a := counts reduce(+)
a println

while(n <= 256, n = reproduce(n, counts, next))
b := counts reduce(+)
b asString(16,0) strip println
