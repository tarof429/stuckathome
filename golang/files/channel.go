package main

import "fmt"

func sum(x, y int, c chan int) {
	c <- x + y
}

func main() {
	c := make(chan int)

	go sum(3, 4, c)

	fmt.Printf("%d\n", <-c)
}
