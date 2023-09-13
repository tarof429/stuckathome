package main

import "fmt"

var remainder int

func getChange(coin int, value int) (change int, remainder int) {
	var minValue = 1

	if value < minValue {
		fmt.Println("No value!")
		return
	}

	change = coin / value
	remainder = coin % value

	return
}

func calculateChange(quarters int) (dimes int, nickels int, pennies int) {

	// The message that we want to print
	var message string

	// Get the number of dimes
	dimes, remainder = getChange(quarters, 10)

	// Get the number of nickels
	if remainder > 0 {
		nickels, remainder = getChange(remainder, 5)
	}

	// The remainder is the number of pennies that we have
	pennies = remainder

	if dimes > 0 && nickels > 0 && pennies > 0 {
		message = "All three coins!"
	} else {
		message = "Not all three coins!"
	}

	fmt.Println(message)

	return
}

func main() {

	dimes, nickels, pennies := calculateChange(45)

	fmt.Println("dimes, nickels, pennies: ", dimes, nickels, pennies)

	dimes, nickels, pennies = calculateChange(78)

	fmt.Println("dimes, nickels, pennies: ", dimes, nickels, pennies)

	dimes, nickels, pennies = calculateChange(7)

	fmt.Println("dimes, nickels, pennies: ", dimes, nickels, pennies)

	dimes, nickels, pennies = calculateChange(0)

	fmt.Println("dimes, nickels, pennies: ", dimes, nickels, pennies)
}