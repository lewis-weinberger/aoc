#!/usr/local/bin/io

List median := method(
    s := self sort
    len := self size
    if(len isEven,
        0.5 * (s at((len / 2) - 1) + s at(len / 2)),
        s at((len / 2) floor)
    )
)

input := File standardInput readLine split(",") map(c, c asNumber)

m := input median
a := input reduce(xs, x, xs + (x - m) abs, 0)
"A) #{a}" interpolate println

fuel := method(k,
    input reduce(xs, x, 
        f := (x - k) abs
        xs + f * (f + 1) / 2,
        0
    )
)

n := input average
b1 := fuel(n floor)
b2 := fuel(n ceil)
"B) #{if(b1 > b2, b2, b1)}" interpolate println
