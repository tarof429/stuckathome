package main

import "fmt"

var (
	firstname, lastname string
)
func main() {
	fmt.Println("Enter your name")
	fmt.Scanln(&firstname, &lastname)

	fmt.Printf("You entered: %s %s\n", firstname, lastname)
}