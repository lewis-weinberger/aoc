#!/usr/local/bin/io

List atGrid := method(row, col, ncol,
    return(self at(col + row * ncol))
)

Board := Object clone

Board init := method(
    super(init)
    self grid := List clone
    self marked := List clone
    25 repeat(self marked push(false))
)

Board hasWon := method(
    for(i, 0, 4,
        row := true
        for(j, 0, 4, row = row and self marked atGrid(i, j, 5))
        if(row, return(true))
    )
    
    for(j, 0, 4,
        col := true
        for(i, 0, 4, col = col and self marked atGrid(i, j, 5))
        if(col, return(true))
    )

    return(false)
)

input := File standardInput readLines
chosen := input at(0) split(",") map(v, v asNumber)
boards := List clone
b := nil
for(i, 1, input size - 1,
    if(input at(i) size == 0,
        b = Board clone
        boards push(b),
        input at(i) splitNoEmpties map(v, v asNumber) foreach(v, b grid push(v))
    )
)

first := true
called := nil
unmarked := 0
chosen foreach(c,
    called = c
    n := 0
    while(n < boards size,
        x := boards at(n)
        i := x grid indexOf(c)
        if(i, x marked atPut(i, true))
        if(x hasWon,
            unmarked = 0
            x marked foreach(j, v, 
                if(v not, unmarked = unmarked + x grid at(j))
            )
            if(first, (called * unmarked) println; first = false)
            boards remove(x)
            n = n - 1
        )
        n = n + 1
    )
    if(boards size == 0, break)
)
(called * unmarked) println
