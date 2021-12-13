#!/usr/local/bin/io

input := File standardInput readLines

dots := Map clone
folds := List clone

coords := true
input foreach(line,
    if(line size == 0, coords = false; continue)

    if(coords, 
        dots atPut(line, 1),
        folds push(line split at(2) split("="))
    )
)

Map fold := method(spec,
    axis := if(spec at(0) == "x", 0, 1)
    threshold := spec at(1) asNumber

    keys := self keys
    keys foreach(k,
        c := k split(",") map(asNumber)
        if(c at(axis) > threshold,
            c atPut(axis, 2 * threshold - c at(axis))
            self atIfAbsentPut("#{c at(0)},#{c at(1)}" interpolate, 1)
            self removeAt(k)
        )
    )

    return(self)
)


"A) #{dots fold(folds at(0)) size}" interpolate println

folds removeFirst
folds foreach(f, dots fold(f))

"B)" println
for(y, 0, 6,
    for(x, 0, 39,
        if(dots hasKey("#{x},#{y}" interpolate),
            "#" print,
            "." print
        )
    )
    " " println
)
