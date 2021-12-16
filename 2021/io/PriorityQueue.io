#!/usr/local/bin/io

PriorityQueue := Object clone do(
    init := method(
        self heap := List clone
        self cost ::= nil
    )

    //doc PriorityQueue with(cost) Create queue with given cost array.
    with := method(cost,
        PriorityQueue clone setCost(cost)
    )
    
    //doc PriorityQueue percolate(index) Restore the heap property from index.
    percolate := method(i,
        n := heap size
        cmp := i

        for(c, 1, 2,
            child := c + 2 * i

            // Min heap, lower value is higher priority
            if(child < n and cost at(heap at(cmp)) > cost at(heap at(child)),
                cmp = child
            )
        )

        if(cmp != i,
            tmp := heap at(i)
            heap atPut(i, heap at(cmp))
            heap atPut(cmp, tmp)
            percolate(cmp)
        )
    )
    
    //doc PriorityQueue push(anObject) Insert new object into the queue.
    push := method(new,
        size := heap size
        heap push(new)
        if(size > 0, for(i, (size / 2) floor - 1, 0, -1, percolate(i)))
        new
    )

    //doc PriorityQueue pop Remove and return the highest priority element.
    pop := method(
        ret := heap at(0)
        if(ret == nil, return ret)
        heap atPut(0, heap last)
        heap removeLast
        percolate(0)
        ret
    )

    //doc PriorityQueue size Return the size of the queue.
    size := method(heap size)
)
