package main

import "fmt"

const Pi = 3.14

func main() {
	const radius = 1.2

	circumference := Pi * (radius * radius)

	fmt.Println(circumference)
	
}