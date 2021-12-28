#!/usr/local/bin/io

inf := Number constants inf

adjacent := method(c,
    y := c at(0)
    x := c at(1)
    return(list(
        list(y, x - 1),
        list(y, x + 1),
        list(y - 1, x),
        list(y + 1, x)
    ))
)

dijkstra := method(start, cavern,
    rows := cavern rows
    cols := cavern cols

    visited := List2D with(rows, cols, false)
    cost := List2D with(rows, cols, inf)
    queue := PriorityQueue with(rows * cols)
    
    cost atPut(start, 0)
    visited atPut(start, true)
    queue push(start, cost at(start))
    while(queue size > 0,
        q := queue pop
        if(q at(0) == rows - 1 and q at(1) == cols - 1, break)
        
        adjacent(q) foreach(c,
            if(cavern isIndexValid(c),
                new := cost at(q) + cavern at(c)
                if(new < cost at(c) and visited at(c) not,
                    cost atPut(c, new)
                    queue push(c, new)
                    visited atPut(c, true)
                )
            )
        )
    )
    cost at(rows - 1, cols - 1)
)

input := File standardInput readLines
cols := input at(0) size
rows := input size
cavern := List2D with(rows, cols, 0)
input foreach(i, line,
    line foreach(j, c,
        cavern atPut(i, j, c asCharacter asNumber)
    )
)

a := dijkstra(list(0, 0), cavern)
"A) #{a}" interpolate println

bigCavern := List2D with(rows * 5, cols * 5, 0)
bigCavern foreach(i, j, c,
    new := cavern at(i mod(rows), j mod(cols)) + (i / rows) floor + (j / cols) floor
    bigCavern atPut(i, j, if(new > 9, new - 9, new))
)

b := dijkstra(list(0, 0), bigCavern)
"B) #{b}" interpolate println
