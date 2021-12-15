#!/usr/local/bin/io

Sequence containsAll := method(subSeq,
    ret := true
    for(i, 0, (subSeq size) - 1,
        if(self contains(subSeq at(i)) not, ret = false)
    )
    ret
)

Sequence containsAllExact := method(subSeq,
    if(subSeq size == self size, 
        return(self containsAll(subSeq)), 
        return(false)
    )
)

input := File standardInput readLines

counts := Map clone
for(i, 0, 9, counts atPut(i asString, 0))

b := 0
input foreach(line,
    s := line split

    signals := s slice(0, 10) sortBy(block(a, b, a size > b size))
    segments := list(
        nil,
        signals at(9),
        nil,
        nil,
        signals at(7),
        nil,
        nil,
        signals at(8),
        signals at(0),
        nil
    )
    
    signals foreach(v,
        len := v size
        if(len == 6,
            if(v containsAll(segments at(4)), 
                segments atPut(9, v),
                if(v containsAll(segments at(1)), 
                    segments atPut(0, v),
                    segments atPut(6, v)
                )
            )
        )

        if(len == 5,
            if(v containsAll(segments at(1)), 
                segments atPut(3, v),
                if(segments at(9) containsAll(v), 
                    segments atPut(5, v),
                    segments atPut(2, v)
                )
            )
        )
    )

    output := Sequence clone
    s slice(11) foreach(i, v,
        num := Sequence clone
        segments foreach(j, w,
            if(v containsAllExact(w),
                jstr := j asString
                num appendSeq(jstr)
                counts atPut(jstr, counts at(jstr) + 1)
            )
        )
        output appendSeq(num)
    )
    b = b + output asNumber
)

a := 0
list(1, 4, 7, 8) foreach(v, a := a + counts at(v asString))

"A) #{a}" interpolate println
"B) #{b}" interpolate println
