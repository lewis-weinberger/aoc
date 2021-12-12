#!/usr/local/bin/io

lines := File standardInput readLines

input := List clone
lines foreach(line,
    for(i, 0, line size - 1, input append(line at(i) asCharacter asNumber))
)

List y := method(self at(0))
List x := method(self at(1))

List isValid := method(
    x := self x
    y := self y
    return(x >= 0 and y >= 0 and x < 10 and y < 10)
)

List atGrid := method(c,
    if(c isValid, return(self at(c x + (c y) * 10)), return(nil))
)

List atGridPut := method(c, v,
    if(c isValid, self atPut(c x + (c y) * 10, v))
)

adjacent := method(c,
    ret := List clone
    for(i, c y - 1, c y + 1,
        for(j, c x - 1, c x + 1,
            if(i == c y and j == c x, continue)
            a := list(i, j)
            if(a isValid, ret push(a))
        )
    )
    return(ret)
)

n := 0
flashes := 0
sync := false
while(sync not,
    queue := List clone
    for(y, 0, 9,
        for(x, 0, 9,
            c := list(y, x)
            new := input atGrid(c) + 1
            input atGridPut(c, new)
            if(new > 9, queue push(c))
        )
    )

    while(queue size > 0,
        q := queue removeFirst
        if(input atGrid(q) > 9,
            if(n < 100, flashes = flashes + 1)
            input atGridPut(q, -200)
            adjacent(q) foreach(v,
                input atGridPut(v, input atGrid(v) + 1)
                if(input atGrid(v) > 9, queue push(v))
            )
        )
    )

    test := true
    input foreach(i, v, 
        if(v < 0, 
            input atPut(i, 0),
            test = false
        )
    )
    n = n + 1
    if(test, sync = true)
)
"A) #{flashes}" interpolate println
"B) #{n}" interpolate println
