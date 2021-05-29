package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func intcode(input []int, noun int, verb int) int {
	// 1202 replacement
	input[1] = noun
	input[2] = verb

	var addr int = 0
loop:
	for addr < len(input) {
		switch input[addr] {
		case 1:
			a := input[addr+1]
			b := input[addr+2]
			c := input[addr+3]
			input[c] = input[a] + input[b]
			addr += 4
		case 2:
			a := input[addr+1]
			b := input[addr+2]
			c := input[addr+3]
			input[c] = input[a] * input[b]
			addr += 4
		case 99:
			break loop
		default:
			addr += 1
		}
	}

	return input[0]
}

func main() {
	stdin := bufio.NewReader(os.Stdin)
	inputString, err := stdin.ReadString('\n')
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	input := strings.Split(inputString[:len(inputString)-1], ",")
	var program []int
	for i := 0; i < len(input); i++ {
		val, err := strconv.Atoi(input[i])
		if err != nil {
			fmt.Println(err)
			continue
		}
		program = append(program, val)
	}

	p := make([]int, len(program))
	copy(p, program) // need to use a copy as intcode mutates program
	fmt.Println("Part 1) Value after program halts =", intcode(p, 12, 2))
outer:
	for noun := 0; noun < 99; noun++ {
		for verb := 0; verb < 99; verb++ {
			copy(p, program)
			if intcode(p, noun, verb) == 19690720 {
				fmt.Printf("Part 2) 100 * %d + %d = %d\n", noun, verb, 100*noun+verb)
				break outer
			}
		}
	}
}
