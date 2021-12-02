#!/usr/local/bin/io

input := File standardInput readLines

h := 0
d := 0
input foreach(v,
    s := v split
    dir := s at(0)
    val := s at(1) asNumber
    dir switch(
        "forward", h = h + val,
        "down", d = d + val,
        "up", d = d - val
    )
)
(h * d) println

h := 0
d := 0
a := 0
input foreach(v,
    s := v split
    dir := s at(0)
    val := s at(1) asNumber
    dir switch(
        "forward", h = h + val; d = d + a * val,
        "down", a = a + val,
        "up", a = a - val
    )
)
(h * d) println
