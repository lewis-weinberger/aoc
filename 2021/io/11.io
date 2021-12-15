#!/usr/local/bin/io

lines := File standardInput readLines

input := List2D with(lines size, lines at(0) size, 0)
lines foreach(i, line,
    line foreach(j, c,
        input atPut(i, j, c asCharacter asNumber)
    )
)

adjacent := method(c,
    y := c at(0)
    x := c at(1)
    ret := List clone
    for(i, y - 1, y + 1,
        for(j, x - 1, x + 1,
            if(i == y and j == x, continue)
            a := list(i, j)
            if(input isIndexValid(a), ret push(a))
        )
    )
    ret
)

n := 0
flashes := 0
sync := false
while(sync not,
    queue := List clone
    input foreach(i, j, v,
        c := list(i, j)
        new := input at(c) + 1
        input atPut(c, new)
        if(new > 9, queue push(c))
    )

    while(queue size > 0,
        q := queue removeFirst
        if(input at(q) > 9,
            if(n < 100, flashes = flashes + 1)
            input atPut(q, -200)
            adjacent(q) foreach(v,
                input atPut(v, input at(v) + 1)
                if(input at(v) > 9, queue push(v))
            )
        )
    )

    test := true
    input foreach(i, j, v, 
        if(v < 0, 
            input atPut(i, j, 0),
            test = false
        )
    )
    n = n + 1
    if(test, sync = true)
)
"A) #{flashes}" interpolate println
"B) #{n}" interpolate println
