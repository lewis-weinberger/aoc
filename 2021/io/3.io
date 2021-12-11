#!/usr/local/bin/io

input := File standardInput readLines

b := "1" at(0)
m := input size / 2
n := input at(0) size
counts := List clone
n repeat(counts push(0))
input foreach(x,
    x foreach(i, y,
        if(y == b, counts atPut(i, counts at(i) + 1))
    )
)

g := 0
e := 0
for(i, 0, n - 1,
    if(counts at(n - 1 - i) > m, 
        g = g + 2 ** i, 
        e = e + 2 ** i
    )
)
"A) #{g * e}" interpolate println

part2 := method(op1, op2,
    rem := input clone
    cnt := counts clone
    k := 0
    while(rem size > 1,
        count := cnt at(k)
        m := rem size / 2
        rem selectInPlace(v,
            (op1 call(count, m) and v at(k) == b) or (op2 call(count, m) and v at(k) != b)
        )

        cnt mapInPlace(v, 0)
        rem foreach(x,
            x foreach(i, y,
                if(y == b, cnt atPut(i, cnt at(i) + 1))
            )
        )
        k = k + 1
    )
    return(rem at(0))
)

ofin := part2(block(a, b, a >= b), block(a, b, a < b))
cfin := part2(block(a, b, a < b), block(a, b, a >= b))
o := 0
c := 0
for(i, 0, n - 1,
    if(ofin at(n - 1 - i) == b, o = o + 2 ** i)
    if(cfin at(n - 1 - i) == b, c = c + 2 ** i)
)
"B) #{o * c}" interpolate println
