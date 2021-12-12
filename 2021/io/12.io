#!/usr/local/bin/io

caves := Map clone
File standardInput readLines foreach(line,
    s := line split("-")
    s foreach(i, cave,
        caves atIfAbsentPut(cave, List clone) append(s at(1 - i))
    )
)

count := method(current, visits, revisitSmall,
    if(current == "end", return(1))
    visits atPut(current, visits at(current) + 1)
    c := 0
    caves at(current) foreach(cave,
        if(cave == "start", continue)
        if(revisitSmall,
            revisit := false
            visits foreach(k, v,
                if(k isLowercase and v > 1, revisit = true)
            )
            if(cave isLowercase and visits at(cave) > 0 and revisit, continue),
            if(cave isLowercase and visits at(cave) > 0, continue)
        )
        c = c + count(cave, visits clone, revisitSmall)
    )
    return(c)
)

visits := Map clone
caves foreach(k, v, visits atPut(k, 0))
"A) #{count(\"start\", visits, false)}" interpolate println

caves foreach(k, v, visits atPut(k, 0))
"B) #{count(\"start\", visits, true)}" interpolate println
