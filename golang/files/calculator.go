package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

func main() {

	reader := bufio.NewReader(os.Stdin)

	var input string

	fmt.Print("Enter the first number: ")

	input, _ = reader.ReadString('\n')

	float1, err := strconv.ParseFloat(strings.TrimSpace(input), 64)

	if err != nil {
		panic("Error")
	}

	fmt.Print("Enter the second number: ")

	input, _ = reader.ReadString('\n')

	float2, err := strconv.ParseFloat(strings.TrimSpace(input), 64)

	if err != nil {
		panic("Error")
	}

	sum := float1 + float2
	sum = math.Round(sum*100) / 100

	fmt.Printf("The sum of %v and %v is %v\n", float1, float2, sum)

}
