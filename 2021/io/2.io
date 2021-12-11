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
"A) #{h * d}" interpolate println

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
"B) #{h * d}" interpolate println
