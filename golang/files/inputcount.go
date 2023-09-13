package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

var nrchars, nrwords, nrlines int

func main() {
	reader := bufio.NewReader(os.Stdin)

	for ;; {
		line, err := reader.ReadString('\n')

		if err != nil {
			panic(err)
		}

		line = strings.Trim(line, "\r\n")

		if line == "S" {
			break
		}
		Counters(line)

		fmt.Printf("Number chars: %d\n", nrchars)
		fmt.Printf("Number words: %d\n", nrwords)
		fmt.Printf("Number lines: %d\n", nrlines)

	}
}

func Counters(input string) {
	nrlines++
	
	chars := strings.Split(input, "")
	nrchars = len(chars)

	words := strings.Split(input, " ")
	nrwords = len(words)


	fmt.Println(input)
}