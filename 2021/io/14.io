#!/usr/local/bin/io

input := File standardInput readLines

rules := Map clone
template := input at(0)
input slice(2) foreach(line,
    s := line split("->") map(strip)
    s0 := s at(0)
    out := List clone
    out push("#{s0 at(0) asCharacter}#{s at(1)}" interpolate)
    out push("#{s at(1)}#{s0 at(1) asCharacter}" interpolate)
    rules atIfAbsentPut(s0, out)
)

counts := Map clone
rules foreach(k, v, counts atPut(k, 0))
for(i, 0, template size - 2,
    pair := template exSlice(i, i + 2)
    counts atPut(pair, counts at(pair) + 1)
)

polymerise := method(
    next := counts clone
    counts foreach(pair, count,
        rules at(pair) foreach(rule,
            next atPut(rule, next at(rule) + count)
        )
        if(count > 0, next atPut(pair, next at(pair) - count))
    )
    counts = next
)

Map pairToSingle := method(
    ret := Map clone
    self foreach(pair, count,
        c := pair exSlice(0, 1)
        ret atPut(c, ret atIfAbsentPut(c, 0) + count)
    )
    final := template exSlice(template size - 1, template size)
    ret atPut(final, ret at(final, 0) + 1)
    ret
)

for(n, 0, 9, polymerise)
single := counts pairToSingle values sort
"A) #{single last - single first}" interpolate println

for(n, 0, 29, polymerise)
single := counts pairToSingle values sort
"B) #{(single last - single first) asString(16,0) strip}" interpolate println
