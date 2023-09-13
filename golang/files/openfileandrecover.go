package main

import "fmt"

func divide(i, j int) int {
	return i /j
}


func main() {
	numbers := []int{1, 2, 3, 4, 5}
	value := 0

	fmt.Println("Calling test")
	test(numbers, value)
	fmt.Println("Test complete")
}

func calculate(numbers[] int, value int) int {
	var sum int

	fmt.Println("Calculating the sum")
	for num := range numbers {
		ret := divide(num, value)
		sum += ret
	}
	return sum
}

func test(numbers [] int, value int) {
	defer func() {
		if e:= recover(); e != nil {
			fmt.Printf("Panicking %s\r\n", e)
		}
	}()

	sum := calculate(numbers, value)

	fmt.Printf("Sum: %d\n", sum)
}