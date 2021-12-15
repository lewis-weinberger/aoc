#!/usr/local/bin/io

List2D := Object clone do(
    init := method(
        self list := List clone
        self rows ::= nil
        self cols ::= nil
    )

    /*doc List2D with(rows, cols, aValue)
    Returns a 2D list of given dimensions, with elements initialised
    to provided value.
    */
    with := method(rows, cols, val,
        r := List2D clone setRows(rows) setCols(cols)
        (rows * cols) repeat(r list push(val))
        r
    )

    /*doc List2D isIndexValid(y, x) Checks if the provided index
    is within the list. If one argument is provided it is treated
    as a list of the coordinate indices.
    */
    isIndexValid := method(
        if(call argCount == 1,
            arg := call evalArgAt(0)
            y := arg at(0)
            x := arg at(1)
        ,
            y := call evalArgAt(0)
            x := call evalArgAt(1)
        )
        
        x >= 0 and y >= 0 and x < self cols and y < self rows
    )

    /*doc List2D at(y, x)
    Returns the value stored at given coordinate, 
    or nil if the coordinate is invalid.
    If one argument is provided it is treated as a list of
    the coordinate indices.
    */
    at := method(
        if(call argCount == 1,
            arg := call evalArgAt(0)
            y := arg at(0)
            x := arg at(1)
        ,
            y := call evalArgAt(0)
            x := call evalArgAt(1)
        )
        if(self isIndexValid(y, x), 
            self list at(x + y * self cols), 
            nil
        )
    )

    /*doc List2D atPut(y, x, aValue)
    Sets the given coordinate to the provided value. Returns the value
    or nil if the coordinate is invalid.
    If two arguments are provided the first is treated as a list of
    the coordinate indices.
    */
    atPut := method(
        if(call argCount == 2,
            arg := call evalArgAt(0)
            y := arg at(0)
            x := arg at(1)
            new := call evalArgAt(1)
        ,
            y := call evalArgAt(0)
            x := call evalArgAt(1)
            new := call evalArgAt(2)
        )

        if(self isIndexValid(y, x), 
            self list atPut(x + y * self cols, new)
            new
        ,
            nil
        )
    )
    
    /*doc List2D indexOf(aValue) Returns a List with coordinates of the first
    instance of the given value.
    */
    indexOf := method(val,
        if(c := self list indexOf(val),
            ret := List clone
            ret push((c / self cols) floor)
            ret push(c mod(self cols))
            ret
        ,
            nil
        )
    )

    /*doc List2D foreach(y, x, value, message) Loops over the list values setting
    the specified index and value slots and executing the message.
    */
    foreach := method(
        if(call argCount != 4, Exception raise("missing arguments"))
        
        y := call argAt(0) name
        x := call argAt(1) name
        val := call argAt(2) name
        msg := call argAt(3)

        context := call sender
        self list foreach(c, v,
            context setSlot(y, (c / self cols) floor)
            context setSlot(x, c mod(self cols))
            context setSlot(val, v)
            status := stopStatus(ret := context doMessage(msg))
            if(status isReturn, 
                call setStopStatus(status)
                return(ret)
            )
            if(status isBreak, break)
            if(status isContinue, continue)
        )
        ret
    )

    //doc List2D asString Returns a String representation of list.
    asString := method(
        r := "List2D:\n" asMutable
        self foreach(i, j, v,
            r appendSeq(v asString .. " ")
            if(j == self cols - 1, r appendSeq("\n"))
        )
    )
)
