#!/usr/local/bin/io

input := File standardInput readLines

cols := input at(0) size
rows := input size
cavern := List2D with(rows, cols, 0)
input foreach(i, line,
    line foreach(j, c,
        cavern atPut(i, j, c asCharacter asNumber)
    )
)




a := 0
b := 0

"A) #{a}" interpolate println
"B) #{b}" interpolate println
