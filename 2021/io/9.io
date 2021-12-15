#!/usr/local/bin/io

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
input := List2D with(m, n, 0)
lines foreach(i, line,
    line foreach(j, c,
        input atPut(i, j, c asCharacter asNumber)
    )
)

lows := List clone
a := 0
for(y, 0, m - 1,
    for(x, 0, n - 1,
        v := input at(list(y, x))
        low := true
        adjacent(y, x) foreach(c,
            if(w := input at(c), 
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
        if(input at(q) < 9,
            basin push(q)
            input atPut(q, 9)
            adjacent(q at(0), q at(1)) foreach(v, 
                if(input isIndexValid(v), queue push(v))
            )
        )
    )
    basins append(basin unique size)
)
"B) #{basins sortBy(block(a, b, a > b)) slice(0, 3) reduce(*)}" interpolate println
