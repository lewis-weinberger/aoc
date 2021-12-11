#!/usr/local/bin/io

input := File standardInput readLines

rules := list(
    list(")", "(", 3),
    list("]", "[", 57),
    list("}", "{", 1197),
    list(">", "<", 25137)
)
a := 0
incomplete := List clone
input foreach(line,
    open := List clone
    corrupted := false
    line foreach(c,
        char := c asCharacter
        if(list("(", "[", "{", "<") contains(char),
            open push(char),
            rules foreach(rule,
                if(char == rule at(0),
                    if(open last != rule at(1),
                        a = a + rule at(2)
                        corrupted = true
                    )
                    open pop
                )
            )
        )
    )
    if(corrupted not, incomplete push(open))
)
"A) #{a}" interpolate println

rules := list("(", "[", "{", "<")
b := List clone
incomplete foreach(line,
    s := 0
    line reverse foreach(char,
        rules foreach(i, rule,
            if(char == rule, s = 5 * s + i + 1)
        )
    )
    b push(s)
)
"B) #{b sort at(b size / 2) asString(16,0) strip}" interpolate println
