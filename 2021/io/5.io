#!/usr/local/bin/io

Sequence parseLine := method(
    coords := List clone
    self splitNoEmpties(" -> ") foreach(c, c split(",") foreach(v, coords push(v asNumber)))
    return(coords)
)

Number sign := method(
    if(self == 0, return(0), return(self / self abs))
)

List findLines := method(overlapMap,
    x0 := self at(0)
    y0 := self at(1)
    x1 := self at(2)
    y1 := self at(3) 
    dx := (x1 - x0) sign
    dy := (y1 - y0) sign
   
    x := x0
    y := y0
    while((y != y1 + dy) or (x != x1 + dx),
        k := x .. "," .. y
        o := overlapMap at(k)
        if(o, overlapMap atPut(k, o + 1), overlapMap atPut(k, 1))
        x = x + dx
        y = y + dy
    )
)

input := File standardInput readLines map(x, x parseLine)

overlap := Map clone
input foreach(v,
    if(v at(0) == v at(2), v findLines(overlap))
    if(v at(1) == v at(3), v findLines(overlap))
)

a := 0
overlap foreach(k, v, if(v >= 2, a = a + 1))
a println

input foreach(v,
    if((v at(0) != v at(2)) and (v at(1) != v at(3)), v findLines(overlap))
)

b := 0
overlap foreach(k, v, if(v >= 2, b = b + 1))
b println
