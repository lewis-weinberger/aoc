#!/usr/local/bin/io

Board := Object clone do(
    init := method(
        self grid := List2D with(5, 5, 0)
        self marked := List2D with(5, 5, false)
    )

    hasWon := method(
        for(i, 0, 4,
            row := true
            for(j, 0, 4, row = row and self marked at(i, j))
            if(row, return(true))
        )
        
        for(j, 0, 4,
            col := true
            for(i, 0, 4, col = col and self marked at(i, j))
            if(col, return(true))
        )

        false
    )
)

input := File standardInput readLines
chosen := input at(0) split(",") map(v, v asNumber)
boards := List clone
b := nil
i := 0
input foreach(in, line,
    if(in == 0, continue)
    if(line size == 0,
        i = 0
        b = Board clone
        boards push(b),
        line splitNoEmpties map(v, v asNumber) foreach(j, v,
            b grid atPut(i, j, v)
        )
        i = i + 1
    )
)

first := true
chosen foreach(c,
    called := c
    n := 0
    while(n < boards size,
        x := boards at(n)
        i := x grid indexOf(c)
        if(i, x marked atPut(i, true))
        if(x hasWon,
            unmarked := 0
            x marked foreach(row, col, v,
                if(v not, unmarked = unmarked + x grid at(row, col))
            )
            if(first,
                "A) #{called * unmarked}" interpolate println
                first = false
            )
            boards remove(x)
            n = n - 1
        )
        n = n + 1
    )
    if(boards size == 0, break)
)
"B) #{called * unmarked}" interpolate println
