#!/usr/local/bin/io

List y := method(self at(0))
List x := method(self at(1))

adjacent := method(y, x,
    return(list(
        list(y, x - 1),
        list(y, x + 1),
        list(y - 1, x),
        list(y + 1, x)
    ))
)

lines := File standardInput readLines

n := lines at(0) size
m := lines size
input := List clone
lines foreach(line,
    for(i, 0, line size - 1, input append(line at(i) asCharacter asNumber))
)

List isValid := method(
    x := self x
    y := self y
    return(x >= 0 and y >= 0 and x < n and y < m)
)

List atGrid := method(c,
    if(c isValid, return(self at(c x + (c y) * n)), return(nil))
)

List atGridPut := method(c, v,
    if(c isValid, self atPut(c x + (c y) * n, v))
)

lows := List clone
a := 0
for(y, 0, m - 1,
    for(x, 0, n - 1,
        v := input atGrid(list(y, x))
        low := true
        adjacent(y, x) foreach(c,
            if(w := input atGrid(c), 
                if(w <= v, low = false))
        )
        if(low,
            a = a + v + 1
            lows append(list(y, x))
        )
    )
)
"A) #{a}" interpolate println

basins := List clone
lows foreach(c,
    basin := List clone
    queue := List clone
    queue push(c)
    while(queue size > 0,
        q := queue removeFirst
        if(input atGrid(q) < 9,
            basin push(q)
            input atGridPut(q, 9)
            adjacent(q y, q x) foreach(v, 
                if(v isValid, queue push(v))
            )
        )
    )
    basins append(basin unique size)
)
"B) #{basins sortBy(block(a, b, a > b)) slice(0, 3) reduce(*)}" interpolate println
