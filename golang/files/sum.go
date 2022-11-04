package main

import (
	"fmt"
	"math"
)

func main() {
	var i int = 10
	var f float64 = 3.1

	fmt.Printf("sum: %v\n", float64(i)+f)

	f1, f2, f3 := 8.1, 1.3, 9.1356
	floatSum := f1 + f2 + f3

	fmt.Println("Float sum: ", math.Round(floatSum*10)/10)
}
