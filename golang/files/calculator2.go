package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

var reader = bufio.NewReader(os.Stdin)

// Calulator is a simple calculator
type Calculator struct {
	Val1, Val2 float64
	Operation  string
}

// GetValue is a function to do simple math on Val1 and Val2
func (c Calculator) GetValue() {

	var result float64

	switch c.Operation {
	case "+":
		result = c.Val1 + c.Val2

	case "-":
		result = c.Val1 - c.Val2
	case "*":
		result = c.Val1 * c.Val2
	case "/":
		result = c.Val1 / c.Val2
	default:
		panic("Invalid operation")
	}

	result = math.Round(result*100) / 100

	fmt.Printf("The result is :%v\n", result)
}

func readValue() float64 {
	input, _ := reader.ReadString('\n')

	float1, err := strconv.ParseFloat(strings.TrimSpace(input), 64)

	if err != nil {
		panic("Error")
	}

	return float1
}

func main() {

	fmt.Print("Enter the first number: ")

	float1 := readValue()

	fmt.Print("Enter the second number: ")

	float2 := readValue()

	fmt.Print("Enter the operation (+ - / *): ")

	op, _ := reader.ReadString('\n')

	var c Calculator

	c.Val1 = float1
	c.Val2 = float2
	c.Operation = strings.TrimSpace(op)

	c.GetValue()

}
