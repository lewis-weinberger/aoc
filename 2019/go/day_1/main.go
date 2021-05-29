package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func fuel(total int, remaining int) int {
	input := (remaining / 3) - 2
	
	if input > 0 {
		return fuel(total+input, input)
	}
	
	return total
}

func main() {
	stdin := bufio.NewScanner(os.Stdin)
	var na, nb int = 0, 0
	
	for stdin.Scan() {
		val, err := strconv.Atoi(stdin.Text())
		if err != nil {
			fmt.Println(err)
			continue
		}
		na += (val / 3) - 2
		nb += fuel(0, val)
	}

	if err := scanner.Err(); err != nil {
	    fmt.Println(err)
	}
	
	fmt.Println("Part 1) Total required fuel =", na)
	fmt.Println("Part 1) Total required fuel =", nb)
}
